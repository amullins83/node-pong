module.exports = (number)->
    number = 8 unless number? and number > 8
    symbols = "-_#$%^&+=?!"
    letters = "abcdefghijklmnopqrstuvwxyz"
    LETTERS = letters.toUpperCase()
    numbers = (String(i) for i in [0..9]).join ""
    chars = [symbols, letters, LETTERS, numbers].join ""
    len = chars.length
    password = ""
    for i in [0...number]
        password += chars[Math.floor Math.random()*len]
    return password
