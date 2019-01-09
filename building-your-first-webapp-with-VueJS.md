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

Despite that the latter maintained respectively by the tech giants _Facebook_ and _Google_, Vue seems highly attractive to many experienced web developers for its design, its flexibility and ease of development. That makes it very appealing for a newbie like me who doesn't know where to start, but who trusts the ones (I believe) who know what they are talking about, like any other hyper-social animal would do! :dolphin: :woman-gesturing-ok: :man-gesturing-ok:

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

Apply the same settings as previously when creating a new project.

From the _Project Dashboard_ you can:

* put widgets
* add Vue CLI plugins
* manage the packages of your dependencies
* configure the tools and "Tasks" to run scripts (e.g. Webpack)

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