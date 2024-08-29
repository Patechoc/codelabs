author:            Patrick Merlot
summary:           Data Processing Reproducibility with DataFlow
id:                data-processing-reproducibility
categories:        education,best-practices,GCP,data-preparation,reproducibility
environments:      Codelabs
status:            draft
feedback link:     github.com/Patechoc/codelabs
analytics account: UA-72074624-2

# Data Processing Reproducibility with DataFlow


## Overview of the tutorial
Duration: 5:00

**Dataflow** is the Google's autoscaling, serverless way of processing both batch and streaming data, a fully-managed cloud version of **Apache Beam** (**B**atch & Str**eam**) on Google Cloud Plateform (GCP).

This tutorial is about learning tools for reproducibility of data processing.
It covers a basic introduction of what Dataflow can do and how to operationalize your local data preparation to build a scalable dat a processing workflow on Google Cloud.

Negative
: The tutorials doesn't cover more data processing reproducibility steps here, but one should also consider where you data is stored and how to make sure no one alters it. One solution for that would be to use BigQuery, designed for immutable data and easily shareable queries on it.

### What you will learn

In this tutorial you will learn to do the following:

* try out Apache Beam in your Python interpreter,
* build and run a simple Python pipeline locally and in the cloud,
* build a concrete pipeline involving BigQuery,
* build a text processing pipeline **[NOT AVAILABLE YET]**,
* build a scalable pre-processing pipeline with TensorFlow **[NOT AVAILABLE YET]**,
* shutdown & clean the cloud resources when you are done.


## Prerequesites

Negative
: Apache Beam only works in Python 2 at the moment [as of Oct. 2018], so make sure to switch to a Python 2 kernel (use `virtualenv` or `conda` for example to build your environment).

You will need a python environment for going through this tutorial. For example:

```shell
conda create -n env_beam python=2.7
conda activate env_beam
```

You will need the Python package manager **pip** which can be installed with:

```shell
sudo apt install python-pip
pip install -U pip
```

Then **Dataflow** and **Oauth2** to authenticate to your GCP account. They can be installed as Python packages:

```shell
pip install google-cloud-dataflow oauth2client==3.0.0`
```

Finally another dependency:

```shell
pip install --force six==1.10  # downgrade as 1.11 breaks apitools`
```

Negative
: This tutorial is still in progress and is missing content... ;)


## Try out Beam in your Python interpreter
Duration: 5:00

```python
>>> import apache_beam as beam


>>> [3, 8, 12] | beam.Map(lambda x : 3*x)
# [9, 24, 36]

>>> [("Jan",3), ("Jan",8), ("Feb",12)] | beam.GroupByKey()
[('Jan', [3, 8]), ('Feb', [12])]


>>> [("Jan",3), ("Jan",8), ("Feb",12)] | beam.GroupByKey() | beam.Map(lambda (mon,days) : (mon,len(days)))
[('Jan', 2), ('Feb', 1)]

```


## Simple Python pipeline
Duration: 20:00

Let's start with a simple sequence of tasks for which we will use Apache Beam. This section is actually a summary of this [Google codelabs](https://codelabs.developers.google.com/codelabs/cpb101-simple-dataflow-py/index.html?index=..%2F..next17#0).

Here we will:
* write a simple pipeline in Python,
* execute the query on the local machine,
* execute the query on the cloud.

### Pipeline running locally

Get data from some files from GitHub:

`wget https://github.com/GoogleCloudPlatform/training-data-analyst/archive/master.zip`

Then navigate to this folder `training-data-analyst-master/courses/data_analysis/lab2/python/`:

`cd master/training-data-analyst-master/courses/data_analysis/lab2/python/`


What about dealing with a few java files:

```shell
$ ls -1 ../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/*.java | xargs -L1 wc -l
58 ../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/Grep.java
129 ../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/IsPopular.java
212 ../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/JavaProjectsThatNeedHelp.java
109 ../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/StreamDemoConsumer.java

ls -1 ../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/*.java | xargs -L1 wc -l
```


Here is Google's first example, [`grep.py`](https://raw.githubusercontent.com/Patechoc/codelabs/master/code/Data_Processing_Reproducibility/grep.py):

```python
#!/usr/bin/env python

"""
Copyright Google Inc. 2016
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import apache_beam as beam
import sys

def my_grep(line, term):
   if line.startswith(term):
      yield line

if __name__ == '__main__':
   p = beam.Pipeline(argv=sys.argv)
   input = '../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/*.java'
   output_prefix = '/tmp/output'
   searchTerm = 'import'

   # find all lines that contain the searchTerm
   (p
      | 'GetJava' >> beam.io.ReadFromText(input)
      | 'Grep' >> beam.FlatMap(lambda line: my_grep(line, searchTerm) )
      | 'write' >> beam.io.WriteToText(output_prefix)
   )

   p.run().wait_until_finish()
```

what it does:

1. read data: `ReadFromText` all input files in `.../dataanalyst/javahelp/*.java`
1. process data: `Grep` every line of each file for a `searchTerm`, here using `searchTerm = 'import'`
1. use output: `WriteToText` in a given folder: `output_prefix = '/tmp/output'`
1. finally run the pipeline to the end `wait_until_finish`.


Notice the 3 respective transforms in the pipeline: **GetJava**, **Grep** and **write**.

Execute this Beam pipeline simply by running this Python file: `python grep.py`


```shell
$ ls /tmp/output*
ls: cannot access '/tmp/output*': No such file or directory
$ python grep.py 
$ ls /tmp/output*
/tmp/output-00000-of-00001
$ 
```

Which produced:

```shell
$ cat /tmp/output-00000-of-00001 
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import com.google.api.services.bigquery.model.TableRow;
...
import org.apache.beam.sdk.transforms.Sum;
import org.apache.beam.sdk.transforms.Top;
import org.apache.beam.sdk.values.KV;
$
```











### Pipeline running on the cloud

####  Create a bucket storage

Let's do that programmatically:

- setup your authentication and setup a project/service account: `../gcloud_gsutil/00_create_service_account.sh` 
- copy data to the cloud (here the java files):

```shell
$ gsutil ls
gs://demo-bucket-patrick/
gs://iris_models/
gs://pme-cx/
$ 
$ BUCKET_NAME="demo-bucket-patrick"
$ 
$ gsutil cp ../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/*.java gs://${BUCKET_NAME}/javahelp
Copying file://../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/Grep.java [Content-Type=text/x-java]...
Copying file://../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/IsPopular.java [Content-Type=text/x-java]...
Copying file://../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/JavaProjectsThatNeedHelp.java [Content-Type=text/x-java]...
Copying file://../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/StreamDemoConsumer.java [Content-Type=text/x-java]...
| [4 files][ 16.7 KiB/ 16.7 KiB]                                                
Operation completed over 4 objects/16.7 KiB.  
$
```
- enable the Dataflow API if not done already (Check [`01_API_enable_with_gcloud.sh`](../gcloud_gsutil/01_API_enable_with_gcloud.sh)).
- modify the Dataflow pipeline ([`grepc.py`](https://raw.githubusercontent.com/Patechoc/codelabs/master/code/Data_Processing_Reproducibility/grepc.py)) to match the `PROJECT_ID` and `BUCKET_NAME`.

```python
#!/usr/bin/env python

"""
Copyright Google Inc. 2016
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import apache_beam as beam

def my_grep(line, term):
   if line.startswith(term):
      yield line

PROJECT='pme-cx'
BUCKET='demo-bucket-patrick'

def run():
   argv = [
      '--project={0}'.format(PROJECT),
      '--job_name=examplejob2',
      '--save_main_session',
      '--staging_location=gs://{0}/staging/'.format(BUCKET),
      '--temp_location=gs://{0}/staging/'.format(BUCKET),
      '--runner=DataflowRunner'
   ]

   p = beam.Pipeline(argv=argv)
   input = 'gs://{0}/javahelp/*.java'.format(BUCKET)
   output_prefix = 'gs://{0}/javahelp/output'.format(BUCKET)
   searchTerm = 'import'

   # find all lines that contain the searchTerm
   (p
      | 'GetJava' >> beam.io.ReadFromText(input)
      | 'Grep' >> beam.FlatMap(lambda line: my_grep(line, searchTerm) )
      | 'write' >> beam.io.WriteToText(output_prefix)
   )

   p.run()

if __name__ == '__main__':
   run()
```

Running it will give you:

```shell
$ python grepc.py 
/home/patrick/anaconda3/envs/ml/lib/python2.7/site-packages/apache_beam/io/gcp/gcsio.py:176: DeprecationWarning: object() takes no parameters
  super(GcsIO, cls).__new__(cls, storage_client))
Collecting apache-beam==2.5.0
  Using cached https://files.pythonhosted.org/packages/c6/96/56469c57cb043f36bfdd3786c463fbaeade1e8fcf0593ec7bc7f99e56d38/apache-beam-2.5.0.zip
  Saved /tmp/tmpqZhUbM/apache-beam-2.5.0.zip
Successfully downloaded apache-beam
Collecting apache-beam==2.5.0
  Using cached https://files.pythonhosted.org/packages/ff/10/a59ba412f71fb65412ec7a322de6331e19ec8e75ca45eba7a0708daae31a/apache_beam-2.5.0-cp27-cp27mu-manylinux1_x86_64.whl
  Saved /tmp/tmpqZhUbM/apache_beam-2.5.0-cp27-cp27mu-manylinux1_x86_64.whl
Successfully downloaded apache-beam
```

- Check your Dataflow job
    On your [Cloud Console](https://console.cloud.google.com/), navigate to the Dataflow section (from the hamburger menu, top-left), and look at the Jobs.

    Select your job and monitor its progress. You will see something like this:

![](https://codelabs.developers.google.com/codelabs/cpb101-simple-dataflow-py/img/8826f7db15d23f15.png)


- Once marked as `Succeeded`. you can examine the output:


```shell
$ gsutil ls gs://demo-bucket-patrick/javahelp/ 
gs://demo-bucket-patrick/javahelp/Grep.java
gs://demo-bucket-patrick/javahelp/IsPopular.java
gs://demo-bucket-patrick/javahelp/JavaProjectsThatNeedHelp.java
gs://demo-bucket-patrick/javahelp/StreamDemoConsumer.java
gs://demo-bucket-patrick/javahelp/output-00000-of-00004
gs://demo-bucket-patrick/javahelp/output-00001-of-00004
gs://demo-bucket-patrick/javahelp/output-00002-of-00004
gs://demo-bucket-patrick/javahelp/output-00003-of-00004
```


## Data Preprocessing using Dataflow
Duration: 30:00

This example creates training/test datasets for a Machine Learning model using Dataflow.

While Pandas is fine for experimenting, it is better for the operationalization of your workflow to do the preprocessing in Beam/Dataflow. This will also help if you need to preprocess data on-the-fly, since Beam/Dataflow can also process streaming data.


This section is built from this great [notebook](https://github.com/GoogleCloudPlatform/training-data-analyst/blob/master/courses/machine_learning/deepdive/06_structured/4_preproc.ipynb) by Lak Valliappa

### Local installation

In this section, you will:

* setup a new Python environment and setup resources on Google Cloud,
* use BigQuery to fetch your dataset: records of birth in the US,
* 


Start by creating a new Python environment:

```shell
conda activate ml
pip uninstall -y google-cloud-dataflow
conda install -y pytz==2018.4
pip install apache-beam[gcp]
```

### Setup your GCP resources

Create a Cloud Storage bucket

```shell
PROJECT='pme-cx'
BUCKET='cloud-training-demos-ml_02'
REGION='us-central1'
gsutil mb -l ${REGION} gs://${BUCKET}
```

### Save the SQL query to use later by querying it from BigQuery in Python

The data is natality data (record of births in the US).

The goal is to:

- predict the baby's weight given a number of factors about the pregnancy and the baby's mother.
- Later, we will want to split the data into training and eval datasets. The hash of the year-month will be used for that.



```sql
# Create SQL query using natality data after the year 2000
query = """
SELECT
  weight_pounds,
  is_male,
  mother_age,
  plurality,
  gestation_weeks,
  ABS(FARM_FINGERPRINT(CONCAT(CAST(YEAR AS STRING), CAST(month AS STRING)))) AS hashmonth
FROM
  publicdata.samples.natality
WHERE year > 2000
"""
```


```shell
pip install datalab
pip install --upgrade google-cloud-bigquery[pandas]
$ ipython

In [1]: import google.datalab.bigquery as bq
In [3]: 
   ...: # Create SQL query using natality data after the year 2000
   ...: query = """
   ...: SELECT
   ...:   weight_pounds,
   ...:   is_male,
   ...:   mother_age,
   ...:   plurality,
   ...:   gestation_weeks,
   ...:   ABS(FARM_FINGERPRINT(CONCAT(CAST(YEAR AS STRING), CAST(month AS STRING)))) AS hashmonth
   ...: FROM
   ...:   publicdata.samples.natality
   ...: WHERE year > 2000
   ...: """

In [4]: df = bq.Query(query + " LIMIT 100").execute().result().to_dataframe()
   ...: df.head()
   ...: 

Out[4]: 
   weight_pounds  is_male  mother_age  plurality  gestation_weeks            hashmonth
0       8.818490    False          17          1               42  1403073183891835564
1       8.141671    False          29          1               38  8904940584331855459
2       5.948072     True          38          1               38  7108882242435606404
3       8.838332     True          27          1               39  3408502330831153141
4       9.259415     True          28          1               38  1088037545023002395

In [5]:
```


### Create ML dataset using Dataflow

Let's use Cloud Dataflow to read in the BigQuery data, do some preprocessing, and write it out as CSV files.

> Instead of using Beam/Dataflow, I had three other options:
> 
> * **Dataprep**: Use Cloud Dataprep to visually author a Dataflow pipeline. Cloud Dataprep also allows me to explore the data, so we could have avoided much of the handcoding of Python/Seaborn calls above as well!
> * **directly TensorFlow**: Read from BigQuery directly using TensorFlow.
> * **BigQuery GUI**: Use the BigQuery console (http://bigquery.cloud.google.com) to run a Query and save the result as a CSV file. For larger datasets, you may have to select the option to "allow large results" and save the result into a CSV file on Google Cloud Storage.

However, in this case, I want to do some preprocessing: modifying data so that we can simulate what is known if no ultrasound has been performed.

If I didn't need preprocessing, I could have used the web console. Also, I prefer to script it out rather than run queries on the user interface, so I am using Cloud Dataflow for the preprocessing.


Apache Beam script: [`DataFlow_Baby_weight.py`](https://raw.githubusercontent.com/Patechoc/codelabs/master/code/Data_Processing_Reproducibility/DataFlow_Baby_weight.py).

Note that after you launch the script above, the actual processing is happening on the cloud. Go to the GCP webconsole to the Dataflow section and monitor the running job. It took about 20 minutes for me.

Finally download the generated .csv files:

```shell
gsutil ls gs://${BUCKET}/babyweight/preproc/*-00000*
```









------------------------------------------------------------------------------------
## Preprocessing at scale using Dataflow (and TensorFlow)
Duration: 20:00


[Preprocessing using tf.transform and Dataflow](https://github.com/GoogleCloudPlatform/training-data-analyst/blob/master/courses/machine_learning/deepdive/06_structured/4_preproc_tft.ipynb): Use the flexibility and scalability of Beam for doing your data processing, and use **TensorFlow Transforms** for its efficiency.

**TensorFlow Transforms**  is a hybrid between Apache Beam and TensorFlow, able to process Beam data transformation on the TensorFlow stack, able to use different hardware (CPUs, GPUs, TPUs).

* You do all your analysis (as usual) in Apache Beam,
* in TensorFlow you can simply apply these transformations.


[**Coming...**](https://bitbucket.org/patrick_merlot/ml_methodology/src/master/Dataflow/README.md)






## Text processing pipeline
Duration: 10:00

[**Coming...**](https://bitbucket.org/patrick_merlot/ml_methodology/src/master/Dataflow/README.md)

































------------------------------------------------------------------------------------
## Shut down your Dataflow resources
Duration: 10:00

In addition to worker resource usage (that are [really cheap](https://cloud.google.com/dataflow/pricing#pricing_details)), a job might consume the following resources, each billed at their own pricing, including but not limited to

* Cloud Storage
* Cloud Pub/Sub
* Cloud Datastore
* Cloud Bigtable
* BigQuery

### How to delete the associated Cloud Storage bucket and its contents

Use `gsutil`:

```shell
BUCKET_NAME="my-cool-bucket"

# You can remove a Cloud Storage bucket by invoking the following command:
gsutil rb gs://${BUCKET_NAME}
```

### How to delete the associated data in BigQuery

According to [Google Best practices](https://cloud.google.com/bigquery/docs/best-practices-storage#use_the_expiration_settings_to_remove_unneeded_tables_and_partitions), deleting BigQuery data is useful if you only work on the most recent data. It is also useful if you are experimenting with data and do not need to preserve it.

If your tables are partitioned by date, the dataset's default table expiration applies to the individual partitions. You can also control partition expiration using the time_partitioning_expiration flag in the CLI or the expirationMs configuration setting in the API. For example, the following command would **expire partitions after 3 days**:

```shell
bq mk --time_partitioning_type=DAY --time_partitioning_expiration=259200 [DATASET].[TABLE]
```

## Resources
Duration: 0:30

Here are a few references to read or watch:

* [How to quickly experiment with Dataflow](https://medium.com/google-cloud/quickly-experiment-with-dataflow-3d5a0da8d8e9)
* [Patterns to Develop, Operationalize, and Maintain ML Models (Cloud Next '18)](https://www.youtube.com/watch?time_continue=25&v=BDjEksUdLz8) (Youtube)

