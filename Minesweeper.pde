

import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs;
public boolean game = true; //ArrayList of just the minesweeper buttons that are mined
public int check = 0;

void setup ()
{
    game = true;
    size(400, 500);
    textAlign(CENTER,CENTER);
    textSize(10);
    // make the manager
    Interactive.make( this );    
 buttons = new MSButton[NUM_ROWS][NUM_COLS];

 for (int i = 0; i<NUM_ROWS; i++) 
    for (int nI = 0; nI<NUM_COLS;nI++)
        buttons[i][nI] = new MSButton(i,nI);
    
 bombs = new ArrayList<MSButton>();

    
    setBombs();
}
public void setBombs() { 
    while (bombs.size()<40) {
     int row = (int)(Math.random()*20);
     int col = (int)(Math.random()*20);
        if (!bombs.contains(buttons[row][col])) {
            bombs.add(buttons[row][col]);
        }
    }
}

public void keyPressed() {
    if (key == 'r') {
        restart();
    }
}

public void restart() {
    setup();
}

public void draw ()
{   
    fill(130);
    background( 0 );
    textSize(30);
    text(40-check+" Bombs Left",150,450);
    textSize(10);

    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{       check=0;
        for (MSButton bomb : bombs) {
            if (bomb.isMarked()) {check++;}
        }
        if (check >= 39) {return true;} 
    return false;
}
public void displayLosingMessage()
{   String loseMessage = "You suck!";
    game=false;
    
    for (MSButton mine : bombs) {
        mine.clicked=true;    
    }
      for (int r = 5; r<=15; r++) {
        for(int i = 6; i<6+loseMessage.length();i++) {
        buttons[r][i].notClick();
        buttons[r][i].notMark();
        buttons[r][i].setLabel(""+ loseMessage.charAt(i-6));    
        }
    }
}
public void displayWinningMessage()
{
    String winMessage = "You Win!";
    game=false;
    for (MSButton[] row : buttons) {
        for (MSButton bob : row) {
            bob.notClick();
            bob.notMark();
            bob.setLabel("");

        }
    }
    for (int r = 5; r<=15; r++) {
        for(int i = 6; i<=13;i++) {
        textSize(32);
        buttons[r][i].setLabel(""+ winMessage.charAt(i-6));    
        }
    }
    textSize(10);
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    public boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public void notClick() {clicked=false;}
    public void notMark() {marked=false;}

    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        if (game==true) {
               clicked = true;

            if (mouseButton==RIGHT) {
                marked=!marked;
                if (marked == false) {clicked=false;}
            }
            else if (!marked && countBombs(r,c)>0) {setLabel(""+countBombs(r,c));}
            else {
                for(int i =-1;i<=1;i++)
              for (int nI = -1;nI<=1;nI++)
              if ((i==0&&nI==0)==false) {
                if (isValid(r+i,c+nI) && !buttons[r+i][c+nI].isClicked()) {buttons[r+i][c+nI].mousePressed();}
              }  
            }
        }

    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) {
          fill(255,0,0);
            displayLosingMessage();
        }
        else if(clicked)
            fill( 200 );

        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
    if (r<20&&c<20&&r>=0&&c>=0) 
    return true;
  else return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;

          for(int i =-1;i<=1;i++)
      for (int nI = -1;nI<=1;nI++)
      if ((i==0&&nI==0)==false) {
        if (isValid(row+i,col+nI) && bombs.contains(buttons[row+i][col+nI])) {numBombs++;}
      }  
        return numBombs;
    }
}



