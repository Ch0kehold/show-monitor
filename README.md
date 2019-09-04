# TV Show Pre Monitor v1.1
A mIRC script that monitors defined pre channels for your favorite TV shows and gives a notification when an episode is released online.

## Installation
Put the file **showmonitor.mrc** wherever you wish. Preferably in a folder with write access.<br />
Open your **mIRC** application, run the **remote script editor**, click **file** and then **load**.

Browse to where you put the file and load it. Bam, it's installed and ready to use.

## Usage
After loading the script, right-click in any channel, query or status window and select **TV Show Pre Monitor**.<br />
You can also type **`/showmon`** anywhere.

Edit the settings as needed. For more information on the various settings, check the help text at the bottom of the GUI while hovering over the part you want help with.

**NOTE:** You will require your own access to pre channels, no such information will be provided through this script.

## Changelog
#### 1.1 Build 190904
* FTR: Get information on next episode if available when checking show info
* FTR: Fixed uninstall feature that would uninstall despite choosing 'no'
* FTR: Added BDRip as source
* VIS: Put Pogdesign link in a better position with regards to above note
* VIS: Jumbled the Pre monitor settings around a bit, now looks better
* VIS: Uh, phrasing!
* BKE: Prioritizes TVMaze ID to fetch info if available
* BKE: Added code to handle when there is a Pre match and show source is Any
* BKE: Removed some old no longer used code
* DEV: Write README.md handler for changelog
* DEV: Added new option to make it easier for me to write new messages

#### 1.0 Build 190829
* Initial commit, woo!


## Contact
If you need to contact me about this script, please make a bug report on the github repository.