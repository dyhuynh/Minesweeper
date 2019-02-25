

import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
void setup ()
{

    size(400, 400);
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
            System.out.println(row+"," + col);
        }
    }
    System.out.println (bombs.size());
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int check = 0;
        for (MSButton bomb : bombs) {
            if (bomb.isMarked()) {check++;}
        }
        if (check >= 2) {return true;} 
        System.out.println(check);   
    return false;
}
public void displayLosingMessage()
{   
    textSize(32);
    text("you lose",300,300);
    textSize(10);
    for (MSButton mine : bombs) {
        mine.clicked=true;    
    }
}
public void displayWinningMessage()
{
    String winMessage = "You Win!";
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

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) {
          fill(255,0,0);
          System.out.println("yeet");
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
      System.out.println(numBombs);
        return numBombs;
    }
}



