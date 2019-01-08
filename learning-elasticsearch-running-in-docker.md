author:            Patrick Merlot
summary:           Learning Elasticsearch by running it in Docker
id:                learning-elasticsearch-running-in-docker
categories:        education,elastic,elk,elasticsearch,docker,docker-compose
environments:      Codelabs
status:            draft
feedback link:     github.com/Patechoc/codelabs
analytics account: UA-72074624-2

# Learning Elasticsearch by running it in Docker

## Overview of the tutorial
Duration: 5:00

[**Elasticsearch**](https://www.elastic.co/products/elasticsearch) is a powerful search engine based on the [Apache Lucene](http://lucene.apache.org/) library

This tutorial is about learning the basics of Elasticsearch, possibly going through all the topics ([Elasticsearch Engineer I & II](https://www.elastic.co/training)) one need to know to pass the certification exam.



### What you will learn

This tutorial doesn't exactly follow the content of the official training, but you will learn to run Elasticsearch on a small **single-node cluster**, running **locally for free on your laptop**.

More specifically, you will learn to do the following:

* Install Elasticsearch using Docker
* Custom your own Docker image of Elasticsearch to configure it as you wish
    * loading data by restoring a snapshot **[incomplete]**
    * processing raw files to load them into Elasticsearch **[incomplete]**
* ... more basic features of ELK (**more coming!!!**)





## Elastic Online Training
Duration: 2:30

Looking for the official Elastic training and certifications, you should check these links:

* Become an Elastic Certified Engineer:
    * [Elasticsearch Engineer I](https://www.elastic.co/training/elasticsearch-engineer-1): learn how to manage deployments and develop solutions.
	 * [Elasticsearch Engineer II](https://www.elastic.co/training/elasticsearch-engineer-2): Develop a deeper understanding of how Elasticsearch works and master advanced deployment techniques.
	 * [Elastic Certified Engineer](https://www.elastic.co/training/certification): Test your Elasticsearch skills with our performance-based certification exam
* How to [register](https://training.elastic.co/WelcomeElasticTrainingSubscription#learning-portal) for a course?

> The training are often virtual courses you can follow from anywhere, but they are live, so you need to register in advance and plan 4 hours a day for 4 days in a row.

### Elastic Engineer I

https://training.elastic.co/instructor-led-training/ElasticsearchEngineerI-Virtual

### Elastic Engineer II

https://training.elastic.co/instructor-led-training/ElasticsearchEngineerII-Virtual




## Installation & Configuration
Duration: 15:00


### Local installation of Elasticsearch

Normal steps to install a single-node Elastic environment would include:

1. Install Java
1. Download and Setup Elastisearch
1. Run Elasticsearch: `<path_to_elasticsearch_root_dir>/bin/elasticsearch`
1. Run Kibana: `<path_to_kibana_root_dir>/bin/kibana`
1. Verify that your installation is working:
	* [http://localhost:5601](http://localhost:5601) -- should display Kibana UI.
	* [http://localhost:9200](http://localhost:9200) -- should return status code 200.


Described below is another way to run Elasticsearch from within a container using Docker. This allows for a simpler, cleaner, (but **temporary**!!) installation of the Elastic stack which makes it practical for learning purposes.

### Prerequisite for any installation of Elasticsearch

[**As prerequisites**](https://elk-docker.readthedocs.io/#prerequisites), Elasticsearch alone needs at least 2GB of RAM to run >> a minimum of 4GB RAM assigned to run in Docker!

Negative :
This is the most frequent reason for your image of Elasticsearch failing to start since Elasticsearch version 5 was released.

On Linux, use `sysctl vm.max_map_count` on the host to view the current value, and see Elasticsearch's documentation on virtual memory for guidance on how to change this value. Note that the limits must be changed on the host; they cannot be changed from within a container.


```shell
~$ sysctl vm.max_map_count 
vm.max_map_count = 65530
```

On Linux, you can increase the limits by running the following command as `root`:

```shell
sysctl -w vm.max_map_count=262144
```

* To set this value permanently, update the `vm.max_map_count` setting in `/etc/sysctl.conf`
* To verify after rebooting, run `sysctl vm.max_map_count`.


### Dockerized version of Elastisearch

[Docker](https://www.docker.com) is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package.
By doing so, thanks to the container, the developer can rest assured that the application will run on any other Linux machine regardless of any customized settings that machine might have that could differ from the machine used for writing and testing the code.


This section describes how to use the `sebp/elk` Docker image, which provides a convenient centralised log server and log management web interface, by packaging Elasticsearch, Logstash, and Kibana, collectively known as ELK.


[the official documentation.](https://elk-docker.readthedocs.io/#prerequisites)

#### Installation from an official Docker image

This type of installation is recommended to get started, but you might be limited later on when you need to configure Elasticsearch and restart it to apply the changes. So if you need to change your configuration, you will have to [(re-)build your Docker image locally](#installation-from-a-local-docker-image).

The RPM and Debian packages will configure this setting automatically. No further configuration is required.

To pull the image from the Docker registry, open a shell prompt and enter:

```shell
docker pull sebp/elk
```

or this one if you haven't configured docker for your own user:

```shell
sudo docker pull sebp/elk
```

#### Usage

Run a container from the image with the following command:

```shell
docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name elk sebp/elk
```

Note - The whole ELK stack will be started. See the Starting services selectively section to selectively start part of the stack.

This command publishes the following ports, which are needed for proper operation of the ELK stack:

* `5601` (Kibana web interface): [http://localhost:5601](http://localhost:5601)
* `9200` (Elasticsearch JSON interface): [http://localhost:9200/](http://localhost:9200/)
* `5044` (Logstash Beats interface, receives logs from Beats such as Filebeat – see the Forwarding logs with Filebeat section).


#### Installation from a custom Docker image

This procedure is of course more cumbersome than pulling a pre-made docker image, but this will allow us to tweak the configuration of our Elasticsearch instance.

Here we will:

* clone the an official Docker recipe to build the Elasticsearch image
* make changes to our configuration of Elasticsearch
* build the ELK containers from that image
* run the same way we would run the official Docker image

1. **Cloning the official image:**

```shell
/$ cd /tmp
/tmp$ git clone https://github.com/spujadas/elk-docker.git
```

2. **Make your changes to the configuration of Elasticsearch**

...
**coming example to be copied from the next section...**



3. **Build and run the ELK containers from that image:**

[You may need to remove any former container with the image name 'elk'](https://github.com/Patechoc/docker_memo#delete-containers-from-a-specific-image) (maybe not necessary **to check!!!!**)

```shell
/tmp$ cd elk-docker/
/tmp/elk-docker$ docker-compose build elk
/tmp/elk-docker$ docker-compose up
```

Go take a cup of coffee or 3 :coffee::coffee::coffee:, it might take 5-10 minutes!


### Configuring Elasticsearch

[Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html)

> Elasticsearch ships with good defaults and requires very little configuration. Most settings can be changed on a running cluster using the _Cluster Update Settings_ API.
> 
> The configuration files should contain settings which are node-specific (such as node.name and paths), or settings which a node requires in order to be able to join a cluster, such as `cluster.name` and `network.host`.

You can configure:

* the Elasticsearch Java Virtual Machine (JVM) with `jvm.otions`
* the Elasticsearch logging with `log4j2.properties`
* Elasticsearh itself with `elasticsearch.yml`

[**Important Elasticsearch configuration**](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html) are mostly settings which need to be considered **before going into production**:

* Path settings
* Cluster name
* Node name
* Network host
* Discovery settings
* Heap size
* Heap dump path
* GC logging
* Temp directory


## Download & Ingest Data
Duration: 20:00

You have 2 options to index the data into Elasticsearch.

* You can either use the **Elasticsearch [snapshot and restore API](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html)** to directly **restore a dataset index from a snapshot**,
* or you can download the raw data from your favorite source and then use to **process it and index the data**.

### Load data by restoring index snapshot

[**Example with NYC restaurants**](https://github.com/elastic/examples/tree/master/Exploring%20Public%20Datasets/nyc_restaurants#option-1-load-data-by-restoring-index-snapshot)

Enter your _local Elasticsearch single-node cluster_ by entering the Docker container running it:

```shell
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                                                              NAMES
bab86b772b05        sebp/elk            "/usr/local/bin/star…"   2 hours ago         Up 2 hours          5044/tcp, 5601/tcp, 9200/tcp, 9300/tcp                                             infallible_saha
$ docker exec -i -t bab86b772b05 /bin/bash
```


Using the option to restore a snapshot involves 4 easy steps:

1. Download and uncompress the index snapshot .tar.gz file into a local folder 

```shell
# Create snapshots directory
mkdir elastic_restaurants
cd elastic_restaurants
# Download index snapshot to elastic_restaurants directory
wget http://download.elasticsearch.org/demos/nyc_restaurants/nyc_restaurants-5-4-3.tar.gz .
# Uncompress snapshot file
tar -xf nyc_restaurants-5-4-3.tar.gz
```

This adds a `nyc_restaurants` subfolder containing the index snapshots.

2. Add `nyc_restaurants` dir to the `path.repo` variable in `elasticsearch.yml` in the `<path_to_elasticsearch_root_dir>/config/` folder. See example [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html#_shared_file_system_repository).. Restart elasticsearch for the change to take effect.

> With Docker, any changes to your Elasticseach's configuration will be lost after a restart of the Docker container.
> 
> One solution is therefore to [edit our Docker image](#installation-from-a-local-docker-image) before re-running it, then you can apply the changes mentioned above.

Register a file system repository for the snapshot (change the value of the “location” parameter below to the location of your restaurants_backup directory)

curl -H "Content-Type: application/json" -XPUT 'http://localhost:9200/_snapshot/restaurants_backup' -d '{
    "type": "fs",
    "settings": {
        "location": "<path_to_nyc_restaurants>/",
        "compress": true,
        "max_snapshot_bytes_per_sec": "1000mb",
        "max_restore_bytes_per_sec": "1000mb"
    }
}'


### Process and load data using Python script


[example script](https://github.com/elastic/examples/tree/master/kibana_nyc_restaurants/Scripts-Python) 







## References
Duration: 0:30

* Starting Elasticsearch ([video](https://www.elastic.co/webinars/getting-started-elasticsearch?baymax=rtp&elektra=docs&storm=top-video&iesrc=ctr))
* Introduction to Kibana ([video](https://www.elastic.co/webinars/getting-started-kibana?baymax=rtp&elektra=docs&storm=top-video&iesrc=ctr))
* Logstash Starter Guide ([video](https://www.elastic.co/webinars/getting-started-logstash?baymax=rtp&elektra=docs&storm=top-video&iesrc=ctr))
* Elastic Cloud ([video series](https://www.youtube.com/watch?v=FOTljFfIvh0&index=2&list=PLhLSfisesZIv16xhlT9VsS2BcqhQkT_n-))
* [Non-codelabs-friendly old tutorial](https://bitbucket.org/civic-hackers-lab/elastic-online-training)