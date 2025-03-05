import de.bezier.guido.*;

import de.bezier.guido.*;
public final static int NUM_ROWS = 5;
public final static int NUM_COLS = 5;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup () {
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c < buttons[r].length; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}

public void setMines() {
  //your code
  int totalMines = 5;
  while(mines.size() < totalMines) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw () {
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}

public boolean isWon() {
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLS; c++) {
      MSButton btn = buttons[r][c];
      if(!mines.contains(btn) && !btn.clicked) {
        return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage() {
  for(int i = 0; i < mines.size(); i++) {
    MSButton mine = mines.get(i);
    mine.setLabel("X");
  }
  textSize(32);
  fill(255, 0, 0);
  text("Game Over!", width/2, height/2);
}

public void displayWinningMessage() {
  textSize(32);
  fill(0, 255, 0);
  text("You Win!", width/2, height/2);
}

public boolean isValid(int r, int c) {
  if (r >= 0 && r < NUM_ROWS) {
    if (c >= 0 && c < NUM_COLS) {
      return true;
    }
  }
  return false;
}

public int countMines(int row, int col) {
  int numMines = 0;
  for (int r = row - 1; r <= row + 1; r++) {
    for (int c = col - 1; c <= col + 1; c++) {
      if (isValid(r, c) && mines.contains(buttons[r][c]) && !(r == row && c == col)) {
        numMines++;
      }
    }
  }
  return numMines;
}

public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col ) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    clicked = true;

    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if(!flagged) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else {
      int neighborMines = countMines(myRow, myCol);
      if(neighborMines > 0) {
        setLabel(neighborMines);
      } else {
        for (int r = myRow - 1; r <= myRow + 1; r++) {
          for (int c = myCol - 1; c <= myCol + 1; c++) {
            if (isValid(r, c) && !buttons[r][c].clicked)
              buttons[r][c].mousePressed();
          }
        }
      }
    }
  }
  public void draw () {    
    if (flagged)
      fill(0);
    else if (clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }

  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }

  public boolean isFlagged() {
    return flagged;
  }
}
