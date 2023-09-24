class fin_de_juego {
  String gameOverText, botonText, puntosText, tiempoText, nombre2;
  int botonX, botonY, botonW, botonH;
  int score;
  float tiempo;
  int size;
  
  
  fin_de_juego(int puntos, float contador,String nombre) {
   // this.gameOverText = "Perdiste!";
    this.botonText = "Reset";
    this.puntosText = "record " + puntos;
    this.botonW = 200;
    this.botonH = 100;
    this.botonX = width/2 - this.botonW/2;
    this.botonY = height/2 - this.botonH/2;
    this.score = puntos;
    this.tiempo = contador;
  
    this.tiempoText = "tiempo " + contador;
    this.nombre2 = "Hasta la proxima " + nombre;
    player.pause();

  }

  void draw_fin() {
    //OVERLAY
    fill(#000000);
    rect(0, 0, width,height );
    image(fin,width/2,height/2-158);
    //STARS
    for (int i = 0; i < 9; i++) {
      float x = random(width);
      float y = random(height);
      stroke(255);
      point(x, y);
    }
    rect(botonX+50, botonY+50, botonW/2, botonH/2);

    //BUTTON
    fill(0);
    stroke(200);
    rect(botonX+50, botonY+50, botonW/2, botonH/2);
    fill(200);
    text(botonText, botonX+60, botonY+85);
    
    //SCORE
    stroke(255);
    fill(255,0,0);
    textSize(35);
    text(puntosText, width/2-150, height - height/4);
     stroke(255);
    fill(255,0,0);
    textSize(35);
    text(tiempoText, width/2-170, height - height/3);
  }

  
  boolean mouseOverButton() {
    return (mouseX > botonX 
      && mouseX < botonX + botonW
      && mouseY > botonY
      && mouseY < botonY + botonH);
  }


  
}
