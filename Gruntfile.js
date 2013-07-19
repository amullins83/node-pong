module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON("package.json"),
        connect: {
            test: {
                port: 3000
            }
        },
        jasmine: {
            src: ['models/**/*.coffee', 'grade/*.coffee'],
            options: {
                specs: ['test/**/*Spec.coffee'],
                host: "http://localhost:<%= connect.test.port %>"
            }
        },
        watch: {
            tests: {
                files: ["<%= jasmine.src %>", "<%= jasmine.options.specs %>"],
                tasks: ["jasmine"]
            }
        }
    });

    grunt.loadNpmTasks("grunt-contrib-jasmine");
    grunt.loadNpmTasks("grunt-contrib-watch");
    grunt.loadNpmTasks("grunt-contrib-connect");


    grunt.registerTask("default", ["watch"]);

};