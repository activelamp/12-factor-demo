# 12-factor-demo
This is a direct fork of ActiveLamp/12-factor-demo; with the intent of attempting to bring it up to date as a Drupal repository for Docker with a Docker-Sync component
facilitating local site development.  In addition to moving to Drupal 8.9.X for the basic install, watch to see if progress is made to add a much richer Composer.Json file
to 'Base' so that a user has a real jump start on a configured Drupal install with some key contributed modules.  The other intent is to work with the Docker-compose files
to add some development tools into the container so that a new developer has some perspective on moving back and forth between their local harddrive and the container.  That way
one can see the changes make locally and how they are 'taking' in the container.  The Docker-Sync capability is set to make sure that is happening automatically behind the scenes
but I find it valuable to 'peek' inside the container when I am trying to debug any bumps (https://docker-sync.readthedocs.io/en/latest/index.html).  That probably has two
general values; 1) just learning and 2) trying to do a 'move' rather than a clean new site install and build.  In this later situation you might want to check #hash, autoload
builds, composer install .json and .lock results, settings.php, local.settings.php, etc. to assure the prior and new container environments have working cross matches.  

The original ActiveLamp repository was contributed by Tom Friedhof.  It takes its name as a 12-factor-demo based upon Heroku putting out a 12-factor recommendation for software
as a service best practices.  Mr. Friedhof provides an explaination of the factors as his original repository in a series of YouTube videos (www.youtube.com/watch?v=FiaLKwdv9TI
and https://www.youtube.com/watch?v=BhdSn6XlmWo).  One of the most critical points is having a Development, Staging-Testing, and Production environment to how you work.  Being
able to use the Docker-Sync in the Development environment so it 'speaks' to your container is a great starting point in what he has provided. As noted above, I believe adding
some development tools for use within the container has some further value.  However, that said, I believe in full alignment with Mr. Friedhof's point of keeping three separate
environments and that NOT having the extra 'tools' in the Production environment makes perfect sense. So as progress is made on this respository, one might expect core container
production elements in a common Docker container definition applicable to all three environments and the inclusion of Development tools only in the Development environment, and
the additional of the Testing Tools only in the Staging-Tesing environment.  All this leads toward an approach to a CI/CD (Continuous Integration/Continous Deployment) logic. 
It is likely that one will want to leverage both a GitHub repository and a DockerHub repository to fully support the CI/CD approach; with separate Dockerfiles for development
and testing being called intothe Base container from DockerHub registry.

If you are reading a GitHub 'Readme' file it might be safe to assume you "get" GIT.  But if not, familiarize yourself with how to use that before diving into this. Obviously this
site has some good help if you are into reading "Managing workflow runs" (on this site).  I think one of the easiest overviews is to see Git and GitHub in use with Visual Studio
Code and there is a good video series on that "Visual Studio Code | How to use git and github"  (https://www.youtube.com/watch?v=Fk12ELJ9Bww).  Plus Visual Studio Code is a good
way to work with Docker "Manage Docker Easily With VS Code" (https://www.youtube.com/watch?v=4I8CRAzPLD4) and Docker Desktop has made it easier to see and manage your containers.
We will also see if we might integrate a Portainer capability in this repository at a later date (https://www.youtube.com/watch?v=d_yCqZIui80).  But back to Git, for a good 
reminder of basics consider "A Git Cheatsheet of Commands You Might Need Daily" (https://medium.com/swlh/git-ready-a-git-cheatsheet-of-commands-you-might-need-daily-8f4bfb7b79cf).
Plus, when your best approach is to take down the containers, clean the old local project install and start over, consider "Everyday Git: Clean up and start over" 
(https://everydayrails.com/2014/02/27/git-reset-clean.html).  If you really want a fairly deep GIT/GITHUB training overview to include setting up your SSH connection for updating
between local and GitHub, using branches and forking, there is about an hour and ten minute video worth watching called "Git and GitHub for Beginners - Crash Course"
(https://www.youtube.com/watch?v=RGOj5yH7evk).

Pulling down the clone:
                          git clone https://github.com/RightsandWrongsgit/12-factor-demo.git

      __NOTE: this example syntax is NOT from the ‘Fork’, so you will want to change the ‘https:// …  ‘ part of it to use your own fork’s clone address.__  

The file to first take a look at in the GitHub repository is that “Makefile” .  Basically you need to think about it as the file that you are going to run to invoke the
installation of everything else.  You can see commands in it that do typical things like Pull and Push images, invoke Docker to install and build, and grab files like the
docker-composer.yml and docker-compose.dev.yml that define the environment.  But the most interesting syntax is the call to docker.sync; a function that basically is the
coordination point for how your HOST outside the container talks with the inside of the container. 

The ‘docker-compose.yml’ file is the place where the container environment is established.  There are all sorts of videos and other resources that tell you how to set up
the container so I don’t go into a bunch of detail here.  The key thing to know is that containers are made up of ‘images’ and that ‘images’ are pulled from places like
DockerHub.  Images are the parts and are assembled into the whole; assuring that the parts talk to each other is one of the key things in defining the docker-compose.yml
file.  Think of what the ActiveLamp/12-factor-demo GitHub has in its docker-compose.yml file is just the core basics.  After you get comfortable with that, you  might want to
take a look at what Docker4Drupal has in its  GitHub repository for this key file and get ideas on what you might add to enhance performance from caching or how you might
include a separate mailing system.  As my project repository develops, you might anticipate we will add further functionality but remember, in a Development, Staging-Testing,
Production orientation to support CI/CD workflow.

Under the php: line in the docker-compose.yml file you will notice  an image: line with a drupal:version (in the original Active/Lamp repository this was image: drupal:8.3-fpm
at the time the original fork was pulled).  It really doesn't specifically matter which drupal version is in this docker-compose.yml file because the actual Drupal install
is done after the fact from the Composer.Json file; but the DockerHub registry image didn't show 8.3-fpm any more and thus one key is to update this starting point to a Drupal 
image that is available on the DockerHub list.  You do this edit before the "MAKE" step is run.

Sharing what you do to your application on the HOST with the container that will run the application you are building.

Next look in the ‘docker.sync.yml’ file at the instruction on the line 7 example; it is telling this tool that we want to share the ‘./src/web/profiles’ directory on our HOST
computer (and all subdirectories and files beneath it) with the container.  We have a related instruction in the docker.compose-dev.yml file to tell php within the container
where it is to get the files it needs.  It says to get those files from ‘drupal-sync’ and then to make them available within the container in the ‘/var/www/html/profiles’
directory. In essence, this says “Use the files from ‘-drupal-sync:’ and mount them in the volume ‘/var/www/html/profiles’ within the container.   REMEMBER THAT IF YOU CHANGE
THE LOCAL HOST DIRECTORY FOR THINGS LIKE EXISTING SITES OR FOR A MULTI-SITE STRATEGY, YOU NEED TO ADJUST THE LINES NOTED IN THE ABOVE TWO POINTS!

A change to the HOST:CONTAINER directory synchronization edit is made between Mr. Friedhof's first and second video. The reason that this change is made is discussed in the
second active lamp video by Tom Friedhof; “Factor Two - Dependency Management with Docker, Drupal, and Composer” (https://www.youtube.com/watch?v=BhdSn6XlmWo).  In a 
nutshell, the reason is because how and where he did the local host installation of Drupal using container; to /var/www/src rather than /var/www/html.  The key thing to 
understand at this point is that the above change is in the docker-sync.yml file where line six is drupal-sync: and line seven is scr: '/.scr' now. Then in the
docker-compose-dev.yml file note for both php and ngnix that volumes are declared where drupal-sync is telling the container where to locate the application files it is
referencing from your local machine as -docker-sync:/var/www:nocopy   You might find "Docker Basics: How to Share Data Between a Docker Container and Host"
(https://thenewstack.io/docker-basics-how-to-share-data-between-a-docker-container-and-host/) a good way to get an overview of what "Volumes" are doing for you in Docker.
    
Lets Get Ready by Putting Drupal On our Local Host Machine
The real key to what Tom Friedhof’s approach is that inclusion of docker-sync so the Host easily coordinates with the docker container.  That said, we need to get Drupal
on the host machine.  Freidhof’s second video really outlines that process through its discussion of Dependency management with Docker, Drupal and Composer.

The Clean New Site Approach:
Not to be confused with ‘docker-compose’ there is something called “Composer” that is a dependency manager for PHP.   Drupal is written in PHP, and Composer has been essential
to working with Drupal since version 8.  Most people who have worked with Drupal are aware of Composer primarily as the thing that makes sure the “Modules” you add to the
basic or core installation of Drupal all work in concert with one another; thus the picture of the orchestra conductor on the Composer website.  You need to have Composer
installed at this point to continue.  (https://getcomposer.org/download/)

To make it easy by leveraging someone else’s good thinking, you can do a search for ‘composer template drupal’ to find a good starting point.  It should take you to a
GitHub - drupal-composer/drupal-project: Composer template for Drupal projects.

TO BE CONTINUED

Add - The expansion of directory structure for backup copies of database files and multi-site workflow managed sites.  Make sure to include modifications of the .gitignore
file but with placeholder non-ignored files in the directories to hold the tree structure.     Per "Dockerize an Existing Project"   (https://drupalize.me/tutorial/dockerize-existing-project?p=3040).

Add - Discussion of a couple hosting option alternatives.   The overview that shows how you put more into your Docker-compose and/or Dockerfile project definitions that later
if its content around 16 minute in includes one realatively generic hosting option "Putting it All Together - Docker, Docker-Compose, NGinx Proxy Manager, and Domain
Routing - How To." (https://www.youtube.com/watch?v=cjJVmAI1Do4).  But also offer the deeper support option of Lagoon with Amazee.io hosting as discussed in "How to manage
Multiple Drupal sites with Lagoon" (https://www.youtube.com/watch?v=R2tIivVvExQ&feature=emb_rel_end) | May want to work directly with Amazee staff on final coordination after
providing them with the basic structure and logic from the other elements in this repo. |  One key element to reconcile is that the multi-site logic of the Logoon approach
discussed in this video takes precedence over the multi-site aspect of the "Dockerize an Existin Project" directory layout; but NOT over the database backup aspects.  And, make
sure a user discussion of the benefits over classic drupal multi-site config approach is provided in summary so they only have to watch the Lagoon video if they want super
detail.  And don't forget to include the "Secrets" approach to protecting credentials in corrdination with the gitignore specifications. 

Add - inclusion of and discussion of detailed workflow value of using the .env approach to environment management.  See if the environment can be fully common between the 
Development, Staging-Testing, and Production elements of each supported site in a multi-site but simply use DockerHub registry held version of each workflow element with 
appropriate Dockerfile versions for each.  (https://gitlab.com/florenttorregrosa-drupal/docker-drupal-project/-/blob/8.x/example.dev.env).

