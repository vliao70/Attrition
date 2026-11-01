class imasquare {
  int row; //<>//
  int col;
  imasquare parent;

  imasquare(int row, int col, imasquare parent) {
    this.row = row;
    this.col = col;
    this.parent = parent;
  }
}
