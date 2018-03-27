function New-BadPassword ([int]$PassLength=10) {
    # Define a list of valid characters
    $ValidChars="A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",`
                "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",`
                "1","2","3","4","5","6","7","8","9","0","$","%","&","(",")","*","+","-","/",":",";","<","=",">","?","@",`
                "[","\","]","^","_","{","}","~"
    # Set our iteration marker to zero
    $i=0
    # Seed the password with enough types of characters that AD won't bark about it and fail to create a user. 
    # WARNING: This is not a secure method for generating a complex password.
    $password='a1@'
    while ($i -le $passlength) {
        # Append a random character from the ValidChars array to the end of the password until we reach $Passlength + the password seed
        # length.
        $password+=Get-Random $ValidChars
        # Obviously, this adds one to our iteration marker so the 'while' statement doesn't run forever
        $i++
    }
    # simply output the password so the function is suitable to be called by things expecting only a string back.
    $password
}
