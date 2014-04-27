/* Text Adventure to Social Media
 * A Rexx script
 * Author: Behnam Litkouhi
 * Purpose: Uses a REXX script to play a text adventure game in Racket
 * and automatically post it to several social media websites.
 */
 
/* Usage: rexx play.rexx [racket path],[text adventure path],[Google+ command] */
 
/* Parse initial arguments */ 
in_arg = arg(1)
parse var in_arg racket_path ',' adventure_path ',' google_plus
parse source operating_system invocation_type rexx_version
os=0
if (operating_system = 'WIN32') then
  os=1

if (os=1) then
	play = racket_path adventure_path '|' tee '-file' results
else
	play = '"'||racket_path||'"'||' '||'"'||adventure_path||'"'||' | '||'"tee" "results"'

play

/* Parse results by line */

file = "results"
str = ""
found = 0
message = ""
done = 0

/* Read in from the file */
do while (lines(file)\=0 & done=0)
	str = linein(file)

    found = pos("Game over!", str, 1)
    if (found > 0) then do
        done = 1

        /* Handle specific types of failure */
        found = pos("outside", str, 1)
        if (found > 0) then do
            message = "was killed by winter weather while trying to escape a zombie-infested Rekhi Hall."
        end
        else do
            found = pos("zombie", str, 1)
            if (found > 0) then do
                message = "was killed by a zombie grad student while trying to escape Rekhi Hall."
            end
            else do
                message = "died trying to escape a zombie-infested Rekhi Hall."
            end
        end
    end
    else do
        found = pos("Victory!", str, 1)

        if (found > 0) then do
            done = 1
            
            /* Handle specific types of victory */
            found = pos("outside", str, 1)
            if (found > 0) then do
                message = "successfully escaped a zombie-infested Rekhi Hall by going outside wearing weather-appropriate clothing."
            end
            else do
                found = pos("Fisher", str, 1)
                if (found > 0) then do
                    message = "successfully escaped a zombie-infested Rekhi Hall by unlocking the door to Fisher Hall and leaving."
                end
                else do
                    message = "succesfully escaped a zombie-infested Rekhi Hall."
                end
            end
        end    
    end
end

if (done=1) then do
    python_str = 'python '||google_plus||' '||'"'||message||'"'
    say python_str
    python_str
end
else do
    say "The game was not finished, so there are no results to share with all of your friends."
end

if (os=1) then
    "del " file 
else
	"rm " file

