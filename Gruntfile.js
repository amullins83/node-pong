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
            // tests: {
            //     files: ["<%= jasmine.src %>", "<%= jasmine.options.specs %>"],
            //     tasks: ["jasmine"]
            // },
            distjs: {
                files: ['public/js/**/*.js'],
                tasks: ["concat:js", "aws_s3:js"]
            },
            distcss: {
                files: ['public/css/**/*.css'],
                tasks: ["concat:css", "aws_s3:css"]
            },
            coffee: {
                files: ['coffee/*.coffee'],
                tasks: ['coffee']
            },
            sass: {
                files: ['scss/*.scss'],
                tasks: ['sass']
            }
        },
        concat: {
            options: {
                separator: ";"
            },
            js: {
                src: [
                        './public/js/lib/angular/angular.min.js',
                        './public/js/lib/angular/angular-resource.min.js',
                        './public/js/lib/angular/angular-sanitize.min.js',
                        './public/js/lib/angular-ui/angular-ui.min.js',
                        './public/js/lib/angular-ui/ui-bootstrap-tpls.min.js',
                        './public/js/lib/angular-ui/angular-ui-ieshiv.min.js',
                        './public/bootstrap/js/bootstrap.min.js',
                        './public/js/app.js',
                        './public/js/controllers.js',
                        './public/js/copyTableToDatabase.js',
                        './public/js/directives.js',
                        './public/js/filters.js',
                        './public/js/gameObjects.js',
                        './public/js/getInputFieldValues.js',
                        './public/js/mongolab.js',
                        './public/js/services.js'
                ],
                dest: './dist/js/application.js'
            },
            css: {
                src: [
                        './public/css/angular-ui.min.css',
                        './public/css/app.css',
                        './public/css/pong.css',
                        './public/bootstrap/css/bootstrap-responsive.min.css',
                        './public/bootstrap/css/bootstrap.min.css'
                ],
                dest: './dist/css/application.css'
            }
        },
        aws_s3: {
            options: {
                accessKeyId: process.env.S3_KEY,
                secretAccessKey: process.env.S3_SECRET,
                bucket: "node-pong",
                region: "us-east-1",
                concurrency: 2
            },
            css: {
                files: [
                    {expand: true, cwd: "dist/css", src: ["application.css"], dest: "assets/css"}
                ]
            },
            js: {
                files: [
                    {expand: true, cwd: "dist/js", src: ["application.js"], dest: "assets/js"}
                ]
            }
        },
        coffee: {
            dist: {
                options: {
                    bare: true
                },
                files: [{
                    expand: true,
                    flatten: true,
                    cwd: "coffee",
                    src: ["*.coffee"],
                    dest: "public/js/",
                    ext: ".js"
                }]
            }
        },
        sass: {
            dist: {
                files: [{
                    expand: true,
                    cwd: 'scss',
                    src: ['*.scss'],
                    dest: 'public/css/',
                    ext: '.css'
                }]
            }
        }
    });

    grunt.loadNpmTasks("grunt-contrib-jasmine");
    grunt.loadNpmTasks("grunt-contrib-concat");
    grunt.loadNpmTasks("grunt-contrib-watch");
    grunt.loadNpmTasks("grunt-contrib-connect");
    grunt.loadNpmTasks("grunt-contrib-coffee");
    grunt.loadNpmTasks("grunt-contrib-sass");
    grunt.loadNpmTasks("grunt-aws-s3");

    grunt.registerTask("default", ["watch"]);

};