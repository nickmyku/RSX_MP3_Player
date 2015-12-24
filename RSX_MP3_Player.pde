//Nicholas Mykulowycz
//Nov 20, 2012
//in car mp3 player sketch

/*
//----------------------------------------------
            BUGS FIXES & CHANGES
//----------------------------------------------

--------------------DONE------------------------

***  4_3  ***
- added volume control through up and down keys

***  4_2  ***
- added song.close() statement to draw to close the song that was playing when it ends, may fix song lagging 
- buffer sized duobled to 4096mbs

***  4_1  ***
- fixed bug that kept songs always randomized
- fixed text formatting

***  4_0  ***
- fixed issue where track buttons wouldnt show up for artists with one song
  # wrong ending index for EndSong arraylist
- fixed issue where final track button failed to show up
  # wrong ending index for EndSong arraylist
- fixed cycle artist button, should now cycle ALL artists IN ORDER
  # createTrackList function would reset artist number even when it wasnt told to 
    'find' the track
- made track list navigation buttons larger
- resized to 800x600 and adjust button placement/size
- added numbers for current artist and song and track seconds, at bottom not finalized

--------------------TO DO-----------------------

* fix skips that occur mid song, may have something to do with HDD spinning down
* hide the cursor?
* re-randomize when tracklist song is selecter?
* adjust colors

*/

import ddf.minim.*;
import controlP5.*;
import java.io.*;
//import java.io.File;


Minim minim;
AudioPlayer song;
AudioMetaData meta;
ControlP5 gui;
Textlabel SongTitle, SongArtist, SongAlbum, CurrentArtist;
Slider VolSlider;
Button UpBang, DownBang;
Textlabel VolLabel;
Textlabel TrackLabel_0, TrackLabel_1, TrackLabel_2, TrackLabel_3, TrackLabel_4;
Textlabel TrackLabel_5, TrackLabel_6, TrackLabel_7, TrackLabel_8, TrackLabel_9;
Bang TrackBang0, TrackBang1, TrackBang2, TrackBang3, TrackBang4;
Bang TrackBang5, TrackBang6, TrackBang7, TrackBang8, TrackBang9;
Textlabel CurrSongLabel, CurrArtistLabel, CurrTimeLabel, Time;

PFont BigFont;
PFont MidFont;
PFont SmallFont;
PFont ButtonFont;
PFont TrackFont;


//varibales
boolean Random = true;
boolean Paused = false;
boolean Randomized = true;
int SongNum = 0;
int ArtistNum = 0;
int Volume = 20;
int TotalSongs = 0;
int TotalArtists = 0;
int num = 0;
int StartSong = 0;
int EndSong = 0;
int SubSet = 0;
int[] TrackList;
String mode = "music";  //music, gps, accelerometer, diagnostic
String LastArtist;
String CurrentSong;
ArrayList Location;
ArrayList RandIndex;
ArrayList Title;
ArrayList Artist;
ArrayList StartTrack;
ArrayList EndTrack;


//constants
final File folder = new File("D:\\MUSIC");
//final File folder = new File("D:\\TEST");  //location of music folder, use double slash for directories
final int BUFFERSIZE = 4096;
final int MAXTRACKLENGTH = 30;
final int MAXSONGLENGTH = 25;
final int MAXARTISTLENGTH = 36;
final int MAXALBUMLENGTH = 41;



boolean sketchFullScreen()  {
  return true;
}

//----------------------------------------------
//                   SETUP
//----------------------------------------------
void setup()
{
  size(800, 600);
  
  minim = new Minim(this);
  
  ButtonFont = createFont("FFScala", 50);
  BigFont = createFont("FFScala", 30);
  MidFont = createFont("FFScala", 19);
  SmallFont = createFont("FFScala", 14);
  
  Location = new ArrayList<String>();
  Title = new ArrayList<String>();
  RandIndex = new ArrayList<String>();
  
  Artist = new ArrayList<String>();
  StartTrack = new ArrayList<String>();
  EndTrack = new ArrayList<String>();
  TrackList = new int[10];
  
  LastArtist = " ";
  findSongs(folder);
  EndTrack.add(TotalSongs);
  //println(Artist);
  //println(StartTrack);
  
  //populate RandIndex with consecutive integers
  for(int i=0; i<TotalSongs; i++)  {
    RandIndex.add(i);
  }
  
  //randomize the numbers
  Collections.shuffle(RandIndex);
  
 
  
  //must load mp3 file on startup
  //convert RandIndex  from object to String
  //convert String to Integer
  //use integer as index to access path from Locations
  song = minim.loadFile(Location.get(Integer.parseInt(RandIndex.get(0).toString())).toString(), BUFFERSIZE);
  meta = song.getMetaData();
  //play and volume set at end of setup
  //song.play();
  //Volume(Volume);
  CurrentSong = meta.title();
  
  gui = new ControlP5(this);
  
  // change the original colors
  gui.setColorForeground(0xffff0000);
  gui.setColorBackground(0xff400000);
  gui.setColorLabel(0xffdddddd);
  gui.setColorValue(0xffffffff);
  gui.setColorActive(0xff800000);

  
  gui.addBang("playPause")
     .setPosition(530,370)
     .setSize(100,60)
     .setLabel(" ");
     ;
     
  gui.addBang("lastSong")
     .setPosition(470,450)
     .setSize(100,60)
     .setLabel(" ");
     ;
     
  gui.addBang("nextSong")
     .setPosition(590,450)
     .setSize(100,60)
     .setLabel(" ");
     
  gui.addToggle("Random")
     .setPosition(470,370)
     .setSize(40,40)
     ;   
     
  gui.addTextlabel("playLabel")
     .setPosition(565,365)
     .setValue(">")
     .setColor(0)
     .setFont(ButtonFont)
     ;     
     
  gui.addTextlabel("nextLabel")
     .setPosition(607,447)
     .setValue(">>")
     .setColor(0)
     .setFont(ButtonFont)
     ;
     
  gui.addTextlabel("lastLabel")
     .setPosition(483,447)
     .setValue("<<")
     .setColor(0)
     .setFont(ButtonFont)
     ;
     
  /*for(int i=0; i<10; i++)  {
    int trackwidth = 30;
    gui.addBang("track"+i)
        .setPosition(55, 50+(i*(trackwidth+5)))
        .setSize(320, trackwidth)
        .setLabel(" ");
        ;
  }*/
  
  final int trx = 67;    //x position of track buttons
  final int ty = 80;     //y start of track buttons
  final int trb = 37;    //hieght of track buttons
  final int trsp = 7;    //spacing in between buttons
  
  TrackBang0 = gui.addBang("track0")
    .setPosition(trx, ty)
    .setSize(320, trb)
    .setLabel(" ")
    ;
    
  TrackBang1 = gui.addBang("track1")
    .setPosition(trx, ty+((trb+trsp)*1))
    .setSize(320, trb)
    .setLabel(" ")
    ;
    
  TrackBang2 = gui.addBang("track2")
    .setPosition(trx, ty+((trb+trsp)*2))
    .setSize(320, trb)
    .setLabel(" ")
    ;
    
  TrackBang3 = gui.addBang("track3")
    .setPosition(trx, ty+((trb+trsp)*3))
    .setSize(320, trb)
    .setLabel(" ")
    ;
    
  TrackBang4 = gui.addBang("track4")
    .setPosition(trx, ty+((trb+trsp)*4))
    .setSize(320, trb)
    .setLabel(" ")
    ;
    
  TrackBang5 = gui.addBang("track5")
    .setPosition(trx, ty+((trb+trsp)*5))
    .setSize(320, trb)
    .setLabel(" ")
    ;
    
  TrackBang6 = gui.addBang("track6")
    .setPosition(trx, ty+((trb+trsp)*6))
    .setSize(320, trb)
    .setLabel(" ")
    ;
    
  TrackBang7 = gui.addBang("track7")
    .setPosition(trx, ty+((trb+trsp)*7))
    .setSize(320, trb)
    .setLabel(" ")
    ;
    
  TrackBang8 = gui.addBang("track8")
    .setPosition(trx, ty+((trb+trsp)*8))
    .setSize(320, trb)
    .setLabel(" ")
    ;
    
  TrackBang9 = gui.addBang("track9")
    .setPosition(trx, ty+((trb+trsp)*9))
    .setSize(320, trb)
    .setLabel(" ")
    ;
      
  final int tlx = 68;    //x position of track labels
  final int tly = 81;     //y start of track labels
  final int tlb = 37;    //hieght of track labels
  final int tlsp = 7;    //spacing in between labels
  TrackFont = createFont("FFScala", 21);
      
  TrackLabel_0 = gui.addTextlabel("txtlabel_0")
     .setPosition(tlx, tly)
     .setValue("Track 1")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  TrackLabel_1 = gui.addTextlabel("txtlabel_1")
     .setPosition(tlx, tly+((tlb+tlsp)*1))
     .setValue("Track 2")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  TrackLabel_2 = gui.addTextlabel("txtlabel_2")
     .setPosition(tlx, tly+((tlb+tlsp)*2))
     .setValue("Track 3")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  TrackLabel_3 = gui.addTextlabel("txtlabel_3")
     .setPosition(tlx, tly+((tlb+tlsp)*3))
     .setValue("Track 4")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  TrackLabel_4 = gui.addTextlabel("txtlabel_4")
     .setPosition(tlx, tly+((tlb+tlsp)*4))
     .setValue("Track 5")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  TrackLabel_5 = gui.addTextlabel("txtlabel_5")
     .setPosition(tlx, tly+((tlb+tlsp)*5))
     .setValue("Track 6")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  TrackLabel_6 = gui.addTextlabel("txtlabel_6")
     .setPosition(tlx, tly+((tlb+tlsp)*6))
     .setValue("Track 7")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  TrackLabel_7 = gui.addTextlabel("txtlabel_7")
     .setPosition(tlx, tly+((tlb+tlsp)*7))
     .setValue("Track 8")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  TrackLabel_8 = gui.addTextlabel("txtlabel_8")
     .setPosition(tlx, tly+((tlb+tlsp)*8))
     .setValue("Track 9")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  TrackLabel_9 = gui.addTextlabel("txtlabel_9")
     .setPosition(tlx, tly+((tlb+tlsp)*9))
     .setValue("Track 10")
     .setColor(255)
     .setFont(TrackFont)
     ;
     
  DownBang = gui.addButton("down")
    .setPosition(10,462)
    .setSize(50,50)
    .setLabel("down")
    ;
    
  UpBang = gui.addButton("up")
    .setPosition(10,80)
    .setSize(50,50)
    .setLabel("up")
    ;
    
  gui.addBang("left1")
    .setPosition(10,220)
    .setSize(50,50)
    .setLabel("left")
    ;
     
  gui.addBang("right1")
    .setPosition(395,220)
    .setSize(50,50)
    .setLabel("right")
    ;
    
  gui.addBang("left10")
    .setPosition(10,300)
    .setSize(50,50)
    .setLabel("fast left")
    ;
     
  gui.addBang("right10")
    .setPosition(395,300)
    .setSize(50,50)
    .setLabel("fast right")
    ; 
    
  
  VolSlider = gui.addSlider("VolumeTouch")
     .setPosition(720,70)
     .setSize(40,440)
     .setRange(0,100)
     .setValue(Volume)
     //.setNumberOfTickMarks(100)
     .setSliderMode(Slider.FLEXIBLE)
     .setLabel("")
     ;
     
  VolLabel = gui.addTextlabel("VolumeNumber")
    .setPosition(728,73)
    .setValue("" + Volume)
    .setColor(255)
    .setFont(SmallFont)
    ;
  
  gui.addTextlabel("volumeLabel")
     .setPosition(720,510)
     .setValue("VOL")
     .setColor(255)
     .setFont(SmallFont)
     ; 
     
  
     
  SongTitle = gui.addTextlabel("title")
     .setPosition(400,15)
     .setFont(BigFont)
     .setWidth(100)
     ;
     
  SongArtist = gui.addTextlabel("artist")
     .setPosition(410,50)
     .setFont(MidFont)
     .setWidth(100)
     ;
 
  SongAlbum = gui.addTextlabel("album")
     .setPosition(410,75)
     .setFont(SmallFont)
     .setWidth(100)
     ;
     
  CurrentArtist = gui.addTextlabel("currArtist")
     .setPosition(15,15)
     .setFont(BigFont)
     .setWidth(100)
     ;
     
  CurrSongLabel = gui.addTextlabel("label1")
     .setPosition(80,570)
     .setFont(SmallFont)
     .setWidth(100)
     .setColor(255)
     ;
     
  CurrArtistLabel = gui.addTextlabel("label2")
     .setPosition(10,570)
     .setFont(SmallFont)
     .setWidth(100)
     .setColor(255)
     ;
     
  CurrTimeLabel = gui.addTextlabel("label3")
     .setPosition(160,570)
     .setFont(SmallFont)
     .setWidth(100)
     .setColor(255)
     ;
     
  Time = gui.addTextlabel("label4")
     .setPosition(250,570)
     .setFont(SmallFont)
     .setWidth(100)
     .setColor(255)
     ;
     

  
  /*MaxSongLabel = gui.addTextlabel("label2")
     .setPosition(70,550)
     .setFont(SmallFont)
     .setWidth(100)
     //.setValue("maxS")
     .setColor(255)
     ;*/
  
  
  
  /*MaxArtistLabel = gui.addTextlabel("label4")
     .setPosition(260,550)
     .setFont(SmallFont)
     .setWidth(100)
     //.setValue("maxA")
     .setColor(255)
     ;*/
  
  
  
  //set title, album, and artist text boxes    
  if(meta.title().length()>MAXSONGLENGTH)  {
    SongTitle.setValue(meta.title().substring(0,MAXSONGLENGTH));
  }
  else  {
    SongTitle.setValue(meta.title());
  }
  
  if(meta.author().length()>MAXARTISTLENGTH)  {
    SongArtist.setValue(meta.author().substring(0,MAXARTISTLENGTH));
  }
  else  {
    SongArtist.setValue(meta.author());
  }
  
  if(meta.album().length()>MAXALBUMLENGTH)  {
    SongAlbum.setValue(meta.album().substring(0,MAXALBUMLENGTH));
  }
  else  {
    SongAlbum.setValue(meta.album());
  }
     
  
    
  createTrackList(meta.author(), meta.title(), true);
  
  //start song
  song.play();
  //set song volume
  volume(Volume);
  
}


//----------------------------------------------
//                   DRAW
//----------------------------------------------
void draw()
{
  background(0);
  stroke(255);
  
  int progress = song.position();
  int total = song.length();
  
  //if current song is 98.5% finished skip to the next song
  if(!song.isPlaying() && !Paused)  {
    song.close();
    //if last song set to first song and re-shuffle
    if(SongNum < (TotalSongs-1))  {
      SongNum++;
    }
    else  {
      SongNum = 0;
      Collections.shuffle(RandIndex);
    }
    changeSong(SongNum);
    song.play();
  }
  
  //if randomized but not random then reassign song number
  if(Randomized && !Random)  {
    Randomized = false;
    SongNum = int(RandIndex.get(SongNum).toString());
  }
  
  //set randomized flag when random is enabled and re-shuffle
  if(!Randomized && Random)  {
    Randomized = true;
    SongNum = 0;
    Collections.shuffle(RandIndex);
  }
  
  //create song progress bar for scrubbing
  fill(100,0,0);
  noStroke();  
  rect(50, 550, 700, 10); 
  fill(255,0,0);
  rect(50, 550, int(700*(float(progress)/float(total))), 10);
  
  CurrTimeLabel.setValue((progress/1000) + "/" + (total/1000));
  Time.setValue(hour() + ":" + minute());
  
}

void stop()
{
  // always close Minim audio classes when you are done with them
  song.close();
  minim.stop();
  
  super.stop();
}

void mousePressed()  {
  //scrub song
  
  //int(((float(mouseX)-50)/700)*song.length)
  if(mouseX>50 && mouseX<750)  {
    if(mouseY>545 && mouseY<600)  {
      song.cue(int(((float(mouseX)-50)/700)*float(song.length())));
    }
  }
  
}

void keyPressed()  {
  if(mode == "music")  {
    if(key == ' ')  {
      playPause();
    }
    if (key == CODED)  {      
      if(keyCode == LEFT)  {
        lastSong();
      }
      if(keyCode == RIGHT)  {
        nextSong();
      }
      if(keyCode == UP)  {
        if(Volume < 100){
          Volume += 1;
          volume(Volume);
          //VolSlider.setValue(Volume);
        }
      }
      if(keyCode == DOWN)  {
        if(Volume > 0){
          Volume -= 1;
          volume(Volume);
          //VolSlider.setValue(Volume);
        }
      }
      if(key == ' ')  {
        playPause();
      }
    }
  }
}

//----------------------------------------------
//                GUI FUNCTIONS
//----------------------------------------------
//controlP5 listener
public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
 
}

float volume(int value){
  // logarithmic math to set song gain from linear volume
  song.setGain((10*log(value))-40);
  // ensures the volume slider displays integer value, also updates it from key set value
  VolSlider.setValue(value);
  // displays the volume value on screen
  VolLabel.setValue("" + value);
  //ensures volume varible gets set even when volume is changed from slider
  Volume = value;
  
  return value;
}

//set volume from slider
void VolumeTouch(){
  int value = volume((int)VolSlider.getValue())

  //VolLabel.setValue("" + value);

  //Volume = value;
}



public void playPause() {
  //println("the next song:");
  if(song.isPlaying()){
    song.pause();
    Paused = true;
  }
  else{
    song.play();
    Paused = false;
  }
    
}

//----------------------------------------------
//                FIND SONGS
//----------------------------------------------

public void findSongs(final File folder)  {  
  
  for (final File fileEntry : folder.listFiles())  {
        if (fileEntry.isDirectory())  {
            findSongs(fileEntry);
        }
        else if(fileEntry.getName().endsWith(".mp3")) {
          
          Location.add(fileEntry.getAbsolutePath());
          
          song = minim.loadFile(Location.get(TotalSongs).toString(), 0);
          meta = song.getMetaData();
          
          Title.add(meta.title());
          
          if(!meta.author().equals(LastArtist))  {
            LastArtist = meta.author();
            StartTrack.add(TotalSongs);
            if(TotalSongs>0)  {
              EndTrack.add(TotalSongs);
            }
            Artist.add(LastArtist);
            TotalArtists++;
          }
          song.close();
          
          
          TotalSongs++;
          
        }
    }
}


//----------------------------------------------
//                CREATE TRACK LIST
//----------------------------------------------

void createTrackList(String ArtistStr, String TrackStr, boolean FindSong)  {
  int index = 0;
  int SongIndex = 0;
  
  CurrentArtist.setValue(ArtistStr);
  
  while(!ArtistStr.equals(Artist.get(index).toString()) && index<TotalArtists)  {
      index++;
  }
  
  //ArtistNum = index;
  
  StartSong = Integer.parseInt(StartTrack.get(index).toString());
  EndSong = Integer.parseInt(EndTrack.get(index).toString());

  //println(StartSong);
  //println(EndSong);
  //println(TotalSongs);

  if(FindSong)  {
    while(!TrackStr.equals(Title.get(SongIndex+StartSong).toString()) && SongIndex<(EndSong-StartSong))  {
      SongIndex++;
    }
    SubSet = int(float(SongIndex)/10);
    
    ArtistNum = index;
  }
  
  if(SubSet == 0)  {
    UpBang.setVisible(false);
  }
  else  {
    UpBang.setVisible(true);
  }
  
  CurrArtistLabel.setValue((ArtistNum+1) + "/" + TotalArtists);
  CurrSongLabel.setValue((SongNum+1) + "/" + TotalSongs);
  
  
  if(((SubSet+1)*10)>=(EndSong-StartSong))  {
    DownBang.setVisible(false);
  }
  else  {
    DownBang.setVisible(true);
  }
  
  
  //assign button track button functions
  for(int i=0; i<10; i++)  {
    if(TotalSongs>(StartSong+i+(10*SubSet))) {
      TrackList[i] = i+StartSong+(10*SubSet);
    }
    
  } 
  
  //track 0 label
  if(EndSong>StartSong+0+(10*SubSet))  {  
    if(Title.get(StartSong+0+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_0.setValue(Title.get(StartSong+0+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_0.setValue(Title.get(StartSong+0+(10*SubSet)).toString());
    }
    
    TrackBang0.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+0+(10*SubSet)).toString()))  {
      TrackLabel_0.setColor(0);
    }
    else  {
      TrackLabel_0.setColor(255);
    }
  }
  else  {
    TrackLabel_0.setValue(" ");
    TrackBang0.hide();
  }
  
  //track 1 label
  if(EndSong>StartSong+1+(10*SubSet))  {
    if(Title.get(StartSong+1+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_1.setValue(Title.get(StartSong+1+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_1.setValue(Title.get(StartSong+1+(10*SubSet)).toString());
    }
    
    TrackBang1.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+1+(10*SubSet)).toString()))  {
      TrackLabel_1.setColor(0);
    }
    else  {
      TrackLabel_1.setColor(255);
    }
  }
  else  {
    TrackLabel_1.setValue(" ");
    TrackBang1.hide();
  }
  
  //track 2 label
  if(EndSong>StartSong+2+(10*SubSet))  {
    if(Title.get(StartSong+2+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_2.setValue(Title.get(StartSong+2+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_2.setValue(Title.get(StartSong+2+(10*SubSet)).toString());
    }
    
    TrackBang2.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+2+(10*SubSet)).toString()))  {
      TrackLabel_2.setColor(0);
    }
    else  {
      TrackLabel_2.setColor(255);
    }
  }
  else  {
    TrackLabel_2.setValue(" ");
    TrackBang2.hide();
  }
  
  //track 3 label
  if(EndSong>StartSong+3+(10*SubSet))  {
    if(Title.get(StartSong+3+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_3.setValue(Title.get(StartSong+3+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_3.setValue(Title.get(StartSong+3+(10*SubSet)).toString());
    }
    
    TrackBang3.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+3+(10*SubSet)).toString()))  {
      TrackLabel_3.setColor(0);
    }
    else  {
      TrackLabel_3.setColor(255);
    }
  }
  else  {
    TrackLabel_3.setValue(" ");
    TrackBang3.hide();
  }
  
  //track 4 label
  if(EndSong>StartSong+4+(10*SubSet))  {
    if(Title.get(StartSong+4+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_4.setValue(Title.get(StartSong+4+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_4.setValue(Title.get(StartSong+4+(10*SubSet)).toString());
    }
    
    TrackBang4.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+4+(10*SubSet)).toString()))  {
      TrackLabel_4.setColor(0);
    }
    else  {
      TrackLabel_4.setColor(255);
    }
  }
  else  {
    TrackLabel_4.setValue(" ");
    TrackBang4.hide();
  }
  
  //track 5 label
  if(EndSong>StartSong+5+(10*SubSet))  {
    if(Title.get(StartSong+5+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_5.setValue(Title.get(StartSong+5+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_5.setValue(Title.get(StartSong+5+(10*SubSet)).toString());
    }
    
    TrackBang5.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+5+(10*SubSet)).toString()))  {
      TrackLabel_5.setColor(0);
    }
    else  {
      TrackLabel_5.setColor(255);
    }
  }
  else  {
    TrackLabel_5.setValue(" ");
    TrackBang5.hide();
  }
  
  //track 6 label
  if(EndSong>StartSong+6+(10*SubSet))  {
    if(Title.get(StartSong+6+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_6.setValue(Title.get(StartSong+6+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_6.setValue(Title.get(StartSong+6+(10*SubSet)).toString());
    }
    
    TrackBang6.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+6+(10*SubSet)).toString()))  {
      TrackLabel_6.setColor(0);
    }
    else  {
      TrackLabel_6.setColor(255);
    }
  }
  else  {
    TrackLabel_6.setValue(" ");
    TrackBang6.hide();
  }
  
  //track 7 label
  if(EndSong>StartSong+7+(10*SubSet))  {
    if(Title.get(StartSong+7+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_7.setValue(Title.get(StartSong+7+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_7.setValue(Title.get(StartSong+7+(10*SubSet)).toString());
    }
    
    TrackBang7.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+7+(10*SubSet)).toString()))  {
      TrackLabel_7.setColor(0);
    }
    else  {
      TrackLabel_7.setColor(255);
    }
  }
  else  {
    TrackLabel_7.setValue(" ");
    TrackBang7.hide();
  }
  
  //track 8 label
  if(EndSong>StartSong+8+(10*SubSet))  {
    if(Title.get(StartSong+8+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_8.setValue(Title.get(StartSong+8+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_8.setValue(Title.get(StartSong+8+(10*SubSet)).toString());
    }
    
    TrackBang8.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+8+(10*SubSet)).toString()))  {
      TrackLabel_8.setColor(0);
    }
    else  {
      TrackLabel_8.setColor(255);
    }
  }
  else  {
    TrackLabel_8.setValue(" ");
    TrackBang8.hide();
  }
  
  //track 9 label
  if(EndSong>StartSong+9+(10*SubSet))  {
    if(Title.get(StartSong+9+(10*SubSet)).toString().length()>MAXTRACKLENGTH)  {
      TrackLabel_9.setValue(Title.get(StartSong+9+(10*SubSet)).toString().substring(0,MAXTRACKLENGTH));
    }
    else  {
      TrackLabel_9.setValue(Title.get(StartSong+9+(10*SubSet)).toString());
    }
    
    TrackBang9.show();
    
    //highlight current Track
    if(TrackStr.equals(Title.get(StartSong+9+(10*SubSet)).toString()))  {
      TrackLabel_9.setColor(0);
    }
    else  {
      TrackLabel_9.setColor(255);
    }
  }
  else  {
    TrackLabel_9.setValue(" ");
    TrackBang9.hide();
  }
    
  

  
}

//----------------------------------------------
//                TRACK NAV BANGS
//----------------------------------------------

//chnage track list - song set --
public void up()  {
  if(SubSet>0){
    SubSet--;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
}

//change track list - song set ++
public void down()  {
  if(StartSong+((SubSet+1)*10)<EndSong){
    SubSet++;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
}

//change tracklist - artist --
public void left1()  {
  SubSet = 0;
  
  //println(ArtistNum + " of " + TotalArtists);
  
  if(ArtistNum>0)  {
    ArtistNum--;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
  else  {
    ArtistNum = TotalArtists-1;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
}

//change track list - artist ++
public void right1()  {
  SubSet=0;
  
  
  
  if(ArtistNum<(TotalArtists-1))  {
    ArtistNum++;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
  else  {
    ArtistNum = 0;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
}


//change tracklist - artist -- fast
public void left10()  {
  SubSet = 0;
  
  //println(ArtistNum + " of " + TotalArtists);
  
  if(ArtistNum>10)  {
    ArtistNum = ArtistNum - 10;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
  else  {
    ArtistNum = TotalArtists-1;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
}

//change track list - artist ++ fast
public void right10()  {
  SubSet=0;
  
  
  
  if(ArtistNum<(TotalArtists-11))  {
    ArtistNum = ArtistNum +10;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
  else  {
    ArtistNum = 0;
    createTrackList(Artist.get(ArtistNum).toString(), CurrentSong, false);
  }
}

public void track0()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[0]);
    Random = true;
  }
  else{
    changeSong(TrackList[0]);
    SongNum = TrackList[0];
  }
}

public void track1()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[1]);
    Random = true;
  }
  else{
    changeSong(TrackList[1]);
    SongNum = TrackList[1];
  }
}

public void track2()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[2]);
    Random = true;
  }
  else{
    changeSong(TrackList[2]);
    SongNum = TrackList[2];
  }
}

public void track3()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[3]);
    Random = true;
  }
  else{
    changeSong(TrackList[3]);
    SongNum = TrackList[3];
  }
}

public void track4()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[4]);
    Random = true;
  }
  else{
    changeSong(TrackList[4]);
    SongNum = TrackList[4];
  }
}

public void track5()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[5]);
    Random = true;
  }
  else{
    changeSong(TrackList[5]);
    SongNum = TrackList[5];
  }
}

public void track6()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[6]);
    Random = true;
  }
  else{
    changeSong(TrackList[6]);
    SongNum = TrackList[6];
  }
}

public void track7()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[7]);
    Random = true;
  }
  else{
    changeSong(TrackList[7]);
    SongNum = TrackList[7];
  }
}

public void track8()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[8]);
    Random = true;
  }
  else{
    changeSong(TrackList[8]);
    SongNum = TrackList[8];
  }
}

public void track9()  {
  boolean rand = Random;
  
  if(rand)  {
    Random = false;
    changeSong(TrackList[9]);
    Random = true;
  }
  else{
    changeSong(TrackList[9]);
    SongNum = TrackList[9];
  }
}

public void nextSong() {
   
  //check if last song was reached
  if(SongNum < (TotalSongs-1)){
    SongNum++;
  }
  else{
    SongNum = 0;
    Collections.shuffle(RandIndex);
  }
  
  delay(150);

  changeSong(SongNum);
  
  
}

public void lastSong() {
  
  //check if first song was reached
  if(SongNum > 0){
    SongNum--;
  }
  else{
    SongNum = TotalSongs-1;
    Collections.shuffle(RandIndex);
  }
  
  delay(150);
  
  changeSong(SongNum);
  
}

//----------------------------------------------
//                CHNAGE SONG
//----------------------------------------------

public void changeSong(int index)  {
  boolean playing = false;
  //println(index);
  //pause song if it was playing
  if(song.isPlaying()){
    playing = true;
    song.close();
  }
  
  
  
  if(Random){
    File f = new File(Location.get(Integer.parseInt(RandIndex.get(index).toString())).toString());
    if(f.exists() && !f.isDirectory()) { 
      song = minim.loadFile(Location.get(Integer.parseInt(RandIndex.get(index).toString())).toString(), BUFFERSIZE);
    }
    else{
      return;
    }
  }
  else  {
    File f = new File(Location.get(index).toString());
    if(f.exists() && !f.isDirectory()) { 
      song = minim.loadFile(Location.get(index).toString(), BUFFERSIZE);
    }
    else{
      return;
    }
  }
  
  meta = song.getMetaData();
  //SongTitle.setValue(meta.title());
  //SongArtist.setValue(meta.author());
  //SongAlbum.setValue(meta.album());
  
  if(meta.title().length()>MAXSONGLENGTH)  {
    SongTitle.setValue(meta.title().substring(0,MAXSONGLENGTH));
  }
  else  {
    SongTitle.setValue(meta.title());
  }
  
  if(meta.author().length()>MAXARTISTLENGTH)  {
    SongArtist.setValue(meta.author().substring(0,MAXARTISTLENGTH));
  }
  else  {
    SongArtist.setValue(meta.author());
  }
  
  if(meta.album().length()>MAXALBUMLENGTH)  {
    SongAlbum.setValue(meta.album().substring(0,MAXALBUMLENGTH));
  }
  else  {
    SongAlbum.setValue(meta.album());
  }
  
  //set volume of new song
  volume(Volume);
  
  //if old song was playing make new song play
  if(playing){
    song.play();
  }
  
  CurrentSong = meta.title();
  
  createTrackList(meta.author(), CurrentSong, true);
  
  println(SongNum);
  println(ArtistNum);

}
