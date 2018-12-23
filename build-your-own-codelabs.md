author:            Patrick Merlot
summary:           Building your own codelabs
id:                building-your-own-codelabs
categories:        education,bast-practices
environments:      Codelabs
status:            draft
feedback link:     github.com/Patechoc/codelabs
analytics account: 72074624

# Building your own codelabs


## Overview of the tutorial
Duration: 0:05

This tutorial shows you how to create host your own codelabs on GitHub. In this tutorial you will do the following: 

* setup your own codelabs plateform.
* create your very first codelab tutorial.

Prerequesites

* Install [go](https://golang.org/doc/install) 
* install [npm](https://www.npmjs.com/get-npm) and [Node.js](https://nodejs.org/) to quickly boot up a http server.

Negative
: This tutorial will only describe how to serve your codelabs on GitHub. It doesn't describe [codelab components](https://github.com/googlecodelabs/codelab-components) (styling for steps and inline surveys) nor the more recent [custom elements](https://github.com/googlecodelabs/codelab-elements). neither how to deploy on [other platforms](https://github.com/googlecodelabs/tools#how-do-i-publish-my-codelabs). 


## Install `claat`
Duration: 0:10

The CLaaT project, **Codelabs as a Thing**, is the tool behind codelabs that gives developers around the world a hands-on experience with Google products.

This project has been implemented as a volunteer project by a small group of dedicated Googlers who care deeply about this kind of “learning by doing” approach to education and it is [opened for anyone to use](https://github.com/googlecodelabs/tools#how-do-i-publish-my-codelabs).

So before building codelabs-based tutorials, you will need to install `claat`, the tool that will convert your formatted tutorial (from a Google Docs or from a markdown file) to a codelab. 

Follow these instructions: https://github.com/googlecodelabs/tools/blob/master/claat/README.md#install

Test your installation by typing `claat --help`. If the help doesn't show up, make sure you properly installed go.




## Generate your tutorial as markdown
Duration: 0:05

You can use this tutorial as an example of markdown-based codelabs.

* Simply download this file: [https://raw.githubusercontent.com/Patechoc/codelabs/master/build-your-own-codelabs.md](https://raw.githubusercontent.com/Patechoc/codelabs/master/build-your-own-codelabs.md)
* Change the content of the tutorial
* Export your markdown as a codelabs by replacing "<CDOELAB-NAME>" by the name of you file: `claat export --prefix "../../" -o docs <CDOELAB-NAME>.md`
* Build all the required dependencies and render the generated codelab as it would appear in production: `cd docs && claat build`

Eventually you can also serve the final app in a simple web server for viewing exported codelabs.
It takes no arguments and presents the current directory contents: `claat serve`




## Generate your tutorial in a Google Docs
Duration: 0:05

Official instructions are [here](https://github.com/googlecodelabs/tools#ok-how-do-i-use-it)



## Deploy your codelabs on GitHub
Duration: 0:10

* Go to the GitHub repository that will host your codelabs (e.g. [https://github.com/Patechoc/codelabs](https://github.com/Patechoc/codelabs))
* Click on the **Settings** tab at the top of the page
* Scroll down to the **GiHub Pages** section
* Selecting the **Source** to be "**master branch /docs folder**" and clicking **Save** will activate GitHub Pages. 

GitHub generates a url to the HTML content served (e.g. [https://patechoc.github.io/codelabs/](https://patechoc.github.io/codelabs/).).  

Congratulations! Your generated codelabs under `docs/` are now hosted by GitHub ;) 