async = require 'async'
fs = require 'fs'
gitRequire = require 'git-require'
gulp = require 'gulp'
{spawn} = require 'child_process'

process.env.GIT_REQUIRE_DIR = __dirname + '/projects'

getMainSite = (cb) ->
  repos = 'nechifor-site': 'git@github.com:paul-nechifor/nechifor-site'
  config = dir: null, repos: repos
  gitRequire.install __dirname, config, cb

buildAll = (cb) ->
  dir = process.env.GIT_REQUIRE_DIR + '/nechifor-site'
  syncDir = __dirname + '/synced/apps/nechifor-site/'
  commands = [
    ['npm', 'install']
    ['npm', 'run', 'build']
    ['rsync', '-a', '--del', dir + '/', syncDir]
  ]
  fn = (cmd, cb) -> run cmd, dir, cb
  async.mapSeries commands, fn, cb

prepareSyncedInstall = (cb) ->
  dir = __dirname + '/synced/install'
  run ['npm', 'install'], dir, cb

run = (cmd, dir, cb) ->
  c = spawn cmd[0], cmd.slice(1), cwd: dir
  c.stdout.on 'data', (data) -> process.stdout.write data
  c.stderr.on 'data', (data) -> process.stderr.write data
  c.on 'close', (code) ->
    return cb 'err-' + code unless code is 0
    cb()

gulp.task 'make-all', (cb) ->
  async.series [
    getMainSite
    buildAll
    prepareSyncedInstall
  ], cb
