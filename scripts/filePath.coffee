(->
	filePath = (path, name)->
        return path + "/" + name

    module.exports = filePath
    
).call this