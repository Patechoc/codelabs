author:            Patrick Merlot
summary:           Building your first web app with VueJS
id:                building-your-first-webapp-with-VueJS
categories:        education,webapp,VueJS,npm,VueCLI
environments:      Codelabs
status:            draft
feedback link:     github.com/Patechoc/codelabs
analytics account: UA-72074624-2

# Building your first web app with VueJS

## Overview of the tutorial
Duration: 5:00

[VueJS](https://vuejs.org/) is one of the 3 most used modern web development framework together with [React](https://reactjs.org) and [Angular](https://angular.io).

Despite that the latter maintained respectively by the tech giants _Facebook_ and _Google_, Vue seems highly attractive to many experienced web developers for its design, its flexibility and ease of development. That makes it very appealing for a newbie like me who doesn't know where to start, but who trusts the ones (I believe) who know what they are talking about, like any other hyper-social species would do! ;)

This tutorial is about **building a web app using VueJS** and **understanding the different components and the build process** to achieve it.
It is the first tutorial in a series that should lead to more advanced features of modern webapps, possibly involving other frameworks for front-end and backend (e.g. React, Angular, Python/Flask).

### What you will learn

In this tutorial you will learn to do the following:
* install Vue and Vue CLI
* configure your project
* serve your web app locally



## Installation
Duration: 10:00

There is probably thousands of way to build a javascript-based project and it makes it overwhelming for someone like me who is not used to build modern web apps and to follow with development trend in that field.

So to get started properly without background, Vue CLI seems like a safe choice, maybe not the best, but Vue CLI seems built for that, simplifying the build of your VueJS web application.

[Here is a video](https://www.youtube.com/watch?v=cP9bhEknW_g) telling you everything you need to know and the installation's steps are the following:

### Install npm & Vue CLI 3

* [Install npm](https://www.npmjs.com/get-npm) on your machine
* then install Vue CLI 3:

```shell
npm i -g @vue/cli
```

## Create & Configure your new project from the command line
Duration: 10:00

### Create your project

Let's build the project named `real-world-vue`:

```shell
vue create real-world-vue
```

### Configure your project

You will be prompted menus where you interact with the arrows, spacebar and Enter on your keyboard.

we will follow the tutoril and pick this setting:

```shell
? Please pick a preset: Manually select features
? Check the features needed for your project: Babel, Router, Vuex, Linter
? Use history mode for router? (Requires proper server setup for index fallback in production) Yes
? Pick a linter / formatter config: Prettier
? Pick additional lint features: (Press <space> to select, <a> to toggle all, <i> to invert selection
)Lint on save
? Where do you prefer placing config for Babel, PostCSS, ESLint, etc.? In dedicated config files
? Save this as a preset for future projects? (y/N) N
```

### Run your project locally

You can open your new project folder and run your project:

```shell
cd real-world-vue
```

`npm run serve` will build our project and serve it as a local host.

you will be prompter the output local url: [http://localhost:8080/](http://localhost:8080/)

## Create & Configure your new project from Vue UI
Duration: 5:00

This seems even simpler and providing much more information [using the Vue User Interface](https://youtu.be/cP9bhEknW_g?t=180).

To open it, simply type `vue ui`.

### Configure your project

Apply the same settings as previously when creating a new project in order to configure it as you wish. This is just as simple as through the command line, but more visually intuitive and bringing many more possibilities.

From the _Project Dashboard_ you can:

* put widgets,
* add Vue CLI plugins,
* manage the packages of your dependencies,
* configure the tools and "Tasks" to run scripts (e.g. [Webpack](https://webpack.js.org/)).


This is how your final app would look like:

```shell
$ tree -L 2
.
|-- README.md
|-- babel.config.js
|-- node_modules ## with all the libraries/dependencies needed to build the project
|   |-- @babel
|   |-- @intervolga
|    ...
|    ...
|   |-- yargs
|   |-- yargs-parser
|   `-- yorkie
|-- package.json
|-- postcss.config.js
|-- public ## put files (like images) that you don't want processed through Webpack
|   |-- favicon.ico
|   `-- index.html
`-- src ## where all our application-code goes (images, fonts, css, ...)
    |-- App.vue ## Root component that all other components are nested within
    |-- assets
    |-- components ## components or building blocks of our Vue app
    |-- main.js ## files that renders our app & mounts it to the DOM
    |-- router.js ## configuration of our Vue Router
    |-- store.js ## configuration of Vuex
    `-- views ## files for the different views or "pages" of our app
```


### Run your project locally

You can open your project from the UI and run it from there or through the command line again:

```shell
cd real-world-vue
npm run serve
```


## Building your app


When running your app with `npm run serve`, you will this message:

```shell
  App running at:
  - Local:   http://localhost:8080/ 
  - Network: http://10.47.11.82:8080/

  Note that the development build is not optimized.
  To create a production build, run npm run build.
```

This is just an indication that the project hasn't been built, optimized and minified using [Webpack](https://webpack.js.org/).

To do it, simply use: `npm run build`.

```shell
npm run build

...
⠏  Building for production...

 DONE  Compiled successfully in 5685ms                                                     1:00:52 PM

  File                                 Size               Gzipped

  dist/js/chunk-vendors.dc64aec3.js    112.84 kb          39.09 kb
  dist/js/app.26301760.js              6.08 kb            2.28 kb
  dist/js/about.d63ad26f.js            0.47 kb            0.33 kb
  dist/css/app.7dae01f4.css            0.42 kb            0.26 kb

  Images and other types of assets omitted.

 DONE  Build complete. The dist directory is ready to be deployed.
 INFO  Check out deployment instructions at https://cli.vuejs.org/guide/deployment.html
```

When complete, it generates a `dist/` directory [ready to be deployed](https://cli.vuejs.org/guide/deployment.html)!