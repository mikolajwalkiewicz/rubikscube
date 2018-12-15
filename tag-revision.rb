#!/usr/bin/env ruby
# tag revision in Ruby

require 'git'

###### ********************************************************* ######
=begin

getLatestTag       // get the latest tag

genNewTag          // increment the last tag

setGitAddCommit    // git add & git commit
getHeadTag         // checks if HEAD commit got a tag

setGitTag          // sets new tag

gitPushTag         // push [origin] [master]
gitPushTag         // push [origin] [new tag]

=end
###### ********************************************************* ######

class Revision

    def initialize(remote, branch)
        @remote = remote
        @branch = branch
        @working_dir = Dir.pwd
        @gop = Git.open(@working_dir)
    end

    # Get the latest tag in repo
    def getLatestTag
        tagged_commits = @gop.tags
        harray = Array.new(tagged_commits)
        all_array = []
        harray.each do |item|
            all_array = all_array.push(@gop.describe(item, :abbrev => 0, :tags => true).slice!(1..-1))
        end

        all_array = all_array.sort_by(&Gem::Version.method(:new))

        return "v#{all_array[-1]}"
    end

    # Generate new tag
    def genNewTag(stripTag)

        latestTag = stripTag.slice!(1..-1).split('.')
    
        tag_major = latestTag[0].to_i
        tag_minor = latestTag[1].to_i
        tag_revision = latestTag[2].to_i
        tag_revision += 1

        tag_incremented = "v#{tag_major}.#{tag_minor}.#{tag_revision}"
        return tag_incremented       
    end

    # Add & commit all the changes to git
    def gitAddCommit
        @gop.add(:all => true)

        begin
            @gop.commit("Automatic version bump")
        rescue Git::GitExecuteError => giterror
            # continue
        end
    end

    # Get the HEAD commit tag
    def getHeadTag
        head_commit_id = @gop.revparse("HEAD")

        begin
          @gop.describe(head_commit_id, :contains => true)
        rescue Git::GitExecuteError => giterror
         # do nothing, continue
        end
    end

    # Set tag
    def setGitTag(newtag)
        #begin
          @gop.add_tag(newtag)
        #rescue Git::GitExecuteError => giterror
        #end
    end

    # Push the changes
    def gitPush
        puts "Pushing commit"
        @gop.push(@remote, @branch)
    end

    # Push the new tag
    def gitPushTag(pushTag)
        puts "Pushing tag"
        @gop.push(@remote, "refs/tags/#{pushTag}")
    end

    # Save file for Bamboo
    def saveFile(saveTag)
        aFile = File.new("config.version", "w+")
        if aFile
            aFile.syswrite("version=#{saveTag}")
            aFile.close
        else
            puts "Unable to write a config.version file!"
        end
    end
end

c1 = Revision.new("origin", "master")

# Condition vars
# w = latest tag
# i = HEAD commit tag
w = c1.getLatestTag
i = c1.getHeadTag


# If there's no tag at all, set initial one
if w.nil?
    puts "Looks like there's no tag at all"
    puts "Setting an initial tag"

    # Set the new tag
    c1.setGitTag("v0.1.0")

    # Generate new tag
    w = c1.getLatestTag

    # Save file for Bamboo
    c1.saveFile(w)

    # git add & git commit
    c1.gitAddCommit

    # Push the changes and new tag
    c1.gitPush
    c1.gitPushTag(w)
elsif i.nil?
    puts "Looks like there's no tag on HEAD commit"
    puts "Setting a new tag"
    # It looks like there's no tag set on HEAD commit

    # Generate new tag
    r = c1.genNewTag(w)

    # Set the output file for bamboo
    c1.saveFile(r)

    # git add & git commit
    c1.gitAddCommit

    # Set the new tag
    c1.setGitTag(r)

    # Push the changes and new tag
    c1.gitPush
    c1.gitPushTag(r)
else
    puts "Looks like the HEAD commit already has a tag"
    # Tag exists

    # If latest tag is not the same as head commit tag
    # update the tag, otherwise there's nothing to do
    # tags are the same.
    unless w == i
        # Setting output file for bamboo
        c1.saveFile(w)

        # git add & git commit
        c1.gitAddCommit

        # set new tag
        c1.setGitTag(w)

        # Push changes
        c1.gitPush
        c1.gitPushTag(w)
    else
       puts "Tag already exists, nothing to do"
    end
end