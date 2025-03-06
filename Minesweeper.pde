import de.bezier.guido.*;

import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private boolean gameOver = false;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup () {
  size(400, 420);
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
  int totalMines = NUM_ROWS;
  while (mines.size() < totalMines) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw () {
  background( 0 );
  if (gameOver) {
    displayLosingMessage();
  } else if (isWon()) {
    displayWinningMessage();
  }
}

public boolean isWon() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      MSButton btn = buttons[r][c];
      if (!mines.contains(btn) && !btn.clicked) {
        return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage() {
  for (int i = 0; i < mines.size(); i++) {
    MSButton mine = mines.get(i);
    mine.setLabel("X");
    mine.setRed();
  }
  textSize(20);
  fill(255, 0, 0);
  text("Game Over!", 200, 410);
}

public void displayWinningMessage() {
  textSize(20);
  fill(0, 255, 0);
  text("You Win!", 200, 410);
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

public void resetGame() {
  gameOver = false;
  mines.clear();
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].reset();
    }
  }
  setMines();
}


public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged, isRed;
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
    isRed = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    if (flagged || clicked || gameOver) {
      return;
    }

    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (!flagged) {
        clicked = false;
      }
      return;
    }
    
      clicked = true;
        
    if (mines.contains(this)) {
      gameOver = true;
      displayLosingMessage();
    } else {
      int neighborMines = countMines(myRow, myCol);
      if (neighborMines > 0) {
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

  public void setRed() {
    isRed = true;
  }

  public void draw () {
    if (flagged)
      fill(0);
    else if (clicked && mines.contains(this) )
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else if (isRed)
      fill(255, 0, 0);
    else
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
    
    if(flagged) {
      drawFlag();
    }
  }
  
  private void drawFlag() {
    float flagX = x + width / 2 - 5;
    float flagY = y + height / 2 - 5;
    
    //flag stick
    stroke(0);
    strokeWeight(3);
    line(flagX, flagY, flagX, flagY - 15);
    
    //flag
    fill(255, 0, 0);
    noStroke();
    rect(flagX - 5, flagY - 15, 10, 6);
  }

  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }

  public void reset() {
    clicked = false;
    flagged = false;
    myLabel = "";
    isRed = false;
  }
}
