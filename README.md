# notifyMe
Desktop notification for matches of your favourite football team
# How to Install
### Instructions
*IMPORTANT*
* Do not give space between the name of the team while setting your favourite team
* WRONG :- teamReal Madrid | RIGHT:- teamRealMadrid
* WRONG:- teamBayern Munich | RIGHT:- teamBayernMunich
* No need to mention "FC"  with the name of team
* WRONG:- teamArsenalFC | RIGHT:- teamArsenal

### Steps 
1. cd ~ 
2. git clone https://github.com/rish9511/notifyMe.git
3. cd ~/notifyMe/src
4. chmod +x notifyMe.sh
5. Run the scrip and provide the name of the football team for which you want to receive notifications. 
  * This is a one time setup
  * ./notifyMe.sh team< Name of the team>  :-see examples below
  * ./notifyMe.sh teamArsenal teamRealMadrid
  * Keyword "team" is important
  * Refer to instructions above for more details on how to provide the name of the team 
  * Upon running the script you will receive a notification for each team notifying whether there was a match or  not 
  * Later if you want to add more teams, just run the script as mentioned above

6. Settin up Crontab
  * cd ~
  * crontab -e (this should fire up the VI editor inside your terminal)
  * Press "i" to go in insert mode
  * At the end of the file add the next two lines
  * #job for football notifications
  * 0 11,16 * * * cd ~/notifyMe/src; ./notifyMe.sh
  * Save the file by pressing "esc" key followed by ":" key , "x" key and Enter key
  
  
  
