# Codelabs

We often learn faster through examples or by simpler settings of more complex systems.

This repository aims at building personal code snippets and simple applications that help me learn, remember and re-use code I may not use often enough yet.

It is also often said that if you want to understand something well... explain it!

> [Google Developers Codelabs](https://codelabs.developers.google.com/) provide a guided, tutorial, hands-on coding experience. Most codelabs will step you through the process of building a small application, or adding a new feature to an existing application. 

Google Codelabs on its own is also an open source project that I re-use here to present such tutorials and examples. Great if it helps others too :)

## Installation 

* Install `claat` - see [https://github.com/googlecodelabs/tools/tree/master/claat](https://github.com/googlecodelabs/tools/tree/master/claat)





## Create a codelab

###  Generate content from markdown

* Write a codelab! See https://github.com/googlecodelabs/ for instructions
* `claat export --prefix "../" -o docs codelab-name.md` 
* build the html version of your tutorial: `cd docs && claat build`
* serve them locally with `claat serve`

and commit & push files to master


###  Generate content from Google Docs

You can also generate a codelab from a GDocs: https://github.com/googlecodelabs/tools#ok-how-do-i-use-it


## Reference

* [NAVIKT codelabs](https://navikt.github.io/codelabs/) is an example of organisation that provides such tutorials, guided hands-on coding experience in order to educate their members, enabling autonomy in their learning pathway and therefore speeding-up their learning process. They were also the inspiration behind this repo.
