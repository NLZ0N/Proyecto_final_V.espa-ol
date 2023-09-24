class Enemigos {
  float tam, x, y;
  int speed = 4;
  int vy = 5; // la velocidad del enemigo
  float angle;
  int Explosion= 1;
  float explosionSize = 0;

  Enemigos(float size) {
    this.tam = size;
    this.x = random(width);
    this.y = -size;
  }

  void drawenemigos() {

      fill(150);
      stroke(150);
     
      image(enemigo,x,y, tam-130,tam-130);
        y +=vy;
      float angle = atan2(jugador.y - y/2-5, jugador.x - x);
      x += cos(angle) * speed;
      y += sin(angle) * speed-2;

      if (random(1) < 0.00001) { // Cambiar la posición del asteroide con una probabilidad del 10%
       x = random(width);
        y = -tam;
       }
     // ellipse(x, y, size-100, size-100);
    
   
  }

  boolean colision(Object other) {
    if (other instanceof Nave) {
      Nave jugador = (Nave) other;
      float ang = 10 * tan(60);
      float distance = dist(x, y, jugador.x, jugador.y - ang); // se disminuyo el area del enemigo para observar adecucadamente la colision de la nave.
      if (distance < tam / 8 + ang + 10) {
        fill(255, 0, 0, 100);
        rect(0, 0, width, height);
        fill(255);
        delay(300);// se coloca un tiempo para poder observar la colision  de la nave con el enemigo. Se debe evitar que pase rapido debido a que no es adecuado para la jugabilidad y el entorno 
        return true;
      }
    } else if (other instanceof Balas) {
      Balas balas = (Balas) other;
      float distance = dist(x, y, balas.x, balas.y);
      println(distance);
      if (distance <= tam /6 + balas.tam / 2) {
        fill(0, 255, 0, 100);
        rect(0, 0, width, height);
        fill(255);
        delay(10);


       
        return true;
      }
    }
    return false;

  }

}
