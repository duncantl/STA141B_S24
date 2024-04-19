# Very Brief Git Tutorial

To access the files in [this repository](https://github.com/duncantl/STA141B_S24), you can use 
+ a Web browser to view the raw files, 
+ download individual files via your Web browser and view them locally in your browser or in a text
  editor, or
+ use git to download all of the files and any updates as I change them.

We'll focus on the last.

Git is very powerful and sophisticated. However, the basics as reasonably simple/straightforward.

You can interact with the git repository via 
+ commands in a shell
+ various UI tools.


I'll focus here on the command line tools. They are universal and what the UIs do for you.

You will need to have git installed on your machine.

## Cloning the Repository

You can create a clone of the github repository on your machine with

```
git clone https://github.com/duncantl/STA141B_S24
```
```
Cloning into 'STA141B_S24'...
remote: Enumerating objects: 171, done.        
remote: Counting objects: 100% (171/171), done.        
remote: Compressing objects: 100% (125/125), done.        
remote: Total 171 (delta 52), reused 154 (delta 35), pack-reused 0        
Receiving objects: 100% (171/171), 1.63 MiB | 11.40 MiB/s, done.
Resolving deltas: 100% (52/52), done.
```
(The numbers may change when you clone the repository.)

The repository is now in a folder/directory named `STA141B_S24/`.


You only need to do this once. (However, you can clone it any number of times if you want.)


Once cloned, the files are on your machine. You can view them, edit them, ...
They are yours to explore and change. 
If you change them and want to get the old ones back, you can:
+ clone the repository again, or
+ you can revert to older versions.

You can create new files of your own in the repository and nobody cares.
You can even add those files to the git repository. 


## Updating 

First, change to the directory on your machine where you originally cloned the repository, e.g.,
```
cd ~/STA141B_S24
```

Now, issue the command 
```
git pull
```
That will fetch any new files and changes to existing files.



If you have changed any files and there is now  a *conflict*  between your version and the one on
github, the `git pull` will stop and tell you. If it can merge the two versions properly, it will do
so.


That's it.
