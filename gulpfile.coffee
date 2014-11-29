fs = require 'fs'
gitRequire = require 'git-require'
gulp = require 'gulp'
{spawn} = require 'child_process'

process.env.GIT_REQUIRE_DIR = __dirname + '/projects'

getMainSite = (cb) ->
  repos = 'nechifor-site': 'git@github.com:paul-nechifor/nechifor-site'
  config = dir: null, repos: repos
  gitRequire.install __dirname, config, cb

gulp.task 'make-all', (cb) ->
  getMainSite (err) ->
    return cb err if err
    cwd = process.env.GIT_REQUIRE_DIR + '/nechifor-site'
    run 'npm', ['install'], cwd, (err) ->
      return cb err if err
      run 'npm', ['run', 'build'], cwd, cb

run = (cmd, args, cwd, cb) ->
  c = spawn cmd, args, cwd: cwd
  c.stdout.on 'data', (data) -> process.stdout.write data
  c.stderr.on 'data', (data) -> process.stderr.write data
  c.on 'close', (code) ->
    return cb 'err-' + code unless code is 0
    cb()
