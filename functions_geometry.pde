//*************************************************
// geometry functions
// last modified: 21/08/16
//
// funzioni di disegno avanzate
//
//**************************************************

public void draw_square_tremble(float side, float tremble)
{
  float half_side = side/2;
  line(half_side+random(tremble), half_side+random(tremble), half_side+random(tremble), -half_side+random(tremble));
  line(half_side+random(tremble), -half_side+random(tremble), -half_side+random(tremble), -half_side+random(tremble));
  line(-half_side+random(tremble), -half_side+random(tremble), -half_side+random(tremble), half_side+random(tremble));
  line(-half_side+random(tremble), half_side+random(tremble), half_side+random(tremble), half_side+random(tremble));
}