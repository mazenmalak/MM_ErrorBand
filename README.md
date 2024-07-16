# MM_ErrorBand

First step:

Located setup.sh and link 
  
    export MM_ERROR=$pwd

source setup.sh

To generate a Config file for initalization:
  
    MM_userdate -o <InitConfig.txt>

In Configuration file (IF A FCL FILE HAS ALREADY BEEN COMPILED BY THE USER PRIOR TO INITIALIZATION STEP):

    GENIE_FILE:
    GENIE_TUNE:
    NUMBER_OF_EVENTS:
    ENGINE_TYPE:
    DESIRED_SYSTEMATCS_FOR_GENERATION[
    fill out in the order of SystId's as in the your .fcl file
    ]

  Above are the only necessary options needed to run. This is also the most preferred method, i.e. having your own fcl made
  
  As of now, GENIEReWeight is the the only ENGINE_TYPE that reliably creates a fcl file that would run. If that is the case, fill out
  the remaining portions.
  
  

To Begin the Initialization:
  
     MM_Init_Setup -i <InitConfig.txt> \\
                -f <FclFile.fcl> \\ ### NOTE: WILL OVERRIDE ANY EXISTING FCL FILE ####             
                --custom_fcl \\    ### TAG IS OPTIONAL AND USED IF FCL FILE HAS BEEN CONSTRUCTED, WILL NOT OVERWRITE AN EXISTING FCL #### 
                -n <NodeFile.root> \\              
                -t <number_of_throws> \\
                -o <OutputThrowFile.root> 


  If at any point in the drawing portion, you forget what systematics went were, open the OutputThrowFile.root and open a h_i and see
  what systematics are avilable in that file.


To Create a Configuration file for your Drawing:
  
    MM_Draw_txt -o <DrawConfig.txt>

  An example of a DrawConfig.txt can be seen in the examples folder

To Draw an errorband:
 
    MM_New_Draw -i <DrawConfig.txt> \\
              -t <number_of_throws> \\ ### Will crash if out of bounds #####
              -o <ErrorbandOutput.root>

