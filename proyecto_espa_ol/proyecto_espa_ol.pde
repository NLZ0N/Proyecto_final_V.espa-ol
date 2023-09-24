import processing.serial.*;//Biblioteca
Serial puerto;
int leer=0;
import javax.swing.JOptionPane;
 String nombre;
/////////////////////////////////////////////////////////////////////
import ddf.minim.*;
Minim minim;
AudioPlayer player;
AudioPlayer player1;
AudioPlayer laser;
//temporizador 
////////////////////////////////////////////////////////////////////
ArrayList<Estrellas> estrellas= new ArrayList<Estrellas>();
int frecuencia_estrellas = 4;
////////////////////////////////////////////////////////////////
Nave jugador;
PImage nave;
///////////////////////////////////////////////////////////////
ArrayList<Enemigos> enemigos = new ArrayList<Enemigos>();
int enemigosFrecuencia = 60;
PImage enemigo;
PImage enemigo2;
//////////////////////////////////////////////////////////////
ArrayList<Balas> balas = new ArrayList<Balas>();
////////////////////////////////////////////////////////////////
//menu//
PImage galaga;
int estado_de_juego;
PImage logo;
int numE = 100;
float[] EX = new float[numE];
float[] EY = new float[numE];
float[] Etam = new float[numE];

////////////////////////////////////////////////////////////////
fin_de_juego Fin;
PImage fin;
int puntos;
///////////////////////////////////////////////////////////////
//Usuario usuario;//Jugador actual 
float contador=0;
int cont_archivo;//Empleado para recorrer un string delarchivo partida.

//////////////////////////////////////////////////////////////
//arduino//

/////////////////////////////////////////

// interfaz entre arduino y processing
// incluyo la libreria del 
// serial.write para mandar desde arduino a procesing
// serial.available // recibe datos de processing a arduino
// seria.read los lee desde arduino ival llega de processing

//myPort.avail

void setup() {
  // fullScreen(P2D);
  size(700, 700);
  //////////////////////////////////////
  jugador = new Nave();
  ////////////////////////////////////////
  minim = new Minim(this);
 // 
  player = minim.loadFile("galaga.mp3");
  player1 = minim.loadFile("fin.mp3");
  laser = minim.loadFile("laser.wav");

  puntos= 0;
  nave = loadImage("nave.png");
  imageMode(CENTER);
  enemigo = loadImage("enemigo.png");
  imageMode(CENTER);
  imageMode(CENTER);
  enemigo2 = loadImage("enemigo2.png");
  fin = loadImage("fin.jpg");
  logo= loadImage("logo.png");
  logo.resize(width/2, height/2);
  imageMode(CENTER);// Redimensionar la imagen de fondo
  logo.resize(400,400);
  ////////////////////////////////////////////////////////////////
  //String Puerto=Serial.list()[0];//Recordar que si se conecta algo previamente colocar 1 en vez de 0.
  //puerto= new Serial(this,Puerto,9600);
   JOptionPane.showInputDialog("¡Bienvenido/a al juego Galaga! Por favor, ingrese su nombre:");
  if (nombre != null) {
    println("Hola, " + nombre + "!");
  } else {
    println("No ingresaste un nombre.");
  }

  /////////////////////////////////////////////////////////////
 int numE = 100;
  for (int i = 0; i < numE; i++) 
  {
       EX[i] = random(width);
         EY[i] = random(height);
              Etam[i] = random(1, 5);
           
  }
  //String NombrePuerto=Serial.list()[0];//Recordar que si se conecta algo previamente colocar 1 en vez de 0.
 // Puerto=new Serial(this, NombrePuerto, 9600);
  // myPort.available(); encuentra la variable desde arduino
}

void draw() {
     
if (estado_de_juego == 0) {
    // Dibujar el menú principal
    background(0);
    fill(255);
    textSize(32);
    // Dibujar la imagen de fondo centrada
    image(logo, width+20 - logo.width/2-150, height-20 - logo.height/2-250);
    fill(255, 0, 0);
    rect(width/2 - 50, height/2 + 20, 100, 50);
    fill(255);
    textSize(17);
    text("Play", width/2 - 16, height/2 + 50);
    fill(255);
    // Dibujar el botón de ayuda
    fill(255,0,0);
    rect(width/2 - 50, height/2 + 100, 99, 49);
    fill(255);
    textSize(17);
    text("Help", width/2-17, height/2 + 130);
    fill(255);
    stroke(255);
    noFill();
      // Dibujar el botón de puntaje
    fill(255,0,0);
    rect(width/2 - 50, height/2 + 180, 99, 49);
    fill(255);
    textSize(17);
    text("Games", width/2 - 26, height/2 + 210);
    fill(255);
    stroke(255);
    noFill();
    noStroke();
    for (int i = 0; i < numE; i++) {
      if (random(1) < 0.5) {
        fill(255); // Blanco
      } else {
        fill(0, 0, 255); // Azul
      }
      ellipse(EX[i], EY[i], Etam[i], Etam[i]);
      
      // Mover las estrellas hacia abajo
      EY[i] += Etam[i];
      
      // Si una estrella sale de la pantalla, volver a colocarla en la parte superior
      if (EY[i] > height) {
        EX[i] = random(width);
        EY[i] = -Etam[i];
      }
    }
  }
  if (Fin != null) {
    Fin.draw_fin();
   
  //  end.stopMusic();
    // player.pausa();
  } else if (estado_de_juego  == 1) {
    background(0);
    draw_estrellas();
    drawAsteroid();
    fill(255, 0, 0);
    stroke(255);
    drawBullet();
   
    jugador.draw_nave();
    stroke(255);
    fill(255);
    textSize(30);
    text("Points: " + puntos, 50, 50);
    colision();
   contador++;
  }
}
void drawBullet() {

  for (int i = 0; i<balas.size(); i++) {

    balas.get(i).draw_balas();
    
  }
}

void colision() {
  for (int i = 0; i < enemigos.size(); i++) {
    Enemigos a = enemigos.get(i);
    if (a.colision(jugador) == true) {
      Fin = new fin_de_juego(puntos,contador,nombre);
      guardarDatos(nombre,puntos);
      
      player1.play();
    }
    for (int b = 0; b < balas.size(); b++) {
      Balas bala = balas.get(b);
      
      if (a.colision(bala) == true) {
        puntos++;
        enemigos.remove(a);
        balas.remove(bala);
        i--;
        b--;
      }
    }
  }
}

//La función drawAsteroid() en Processing se utiliza para dibujar asteroides en la pantalla. En esta función, se utiliza la variable frameCount para determinar cuándo se debe agregar un nuevo asteroide a la lista de asteroides. Si el número de cuadros que se han dibujado desde el inicio del programa es un múltiplo de la frecuencia de los asteroides (asteroidFrequency), entonces se agrega un nuevo asteroide a la lista.
//Luego, se recorre la lista de asteroides y se llama al método drawAsteroid() de cada asteroide para dibujarlo en la pantalla. Si un asteroide ha salido de la pantalla (es decir, si su posición y es mayor que la altura de la pantalla más su tamaño), entonces se elimina de la lista de asteroides y se decrementa el puntaje del jugador.
void drawAsteroid() {
  if (frameCount % enemigosFrecuencia == 0) {
    enemigos.add(new Enemigos(random(150, 250)));
  }
  for (int i = 0; i<enemigos.size(); i++) {
    Enemigos currentAsteroid = enemigos.get(i);
    currentAsteroid.drawenemigos();
    if (currentAsteroid.y > height + currentAsteroid.tam) {
      enemigos.remove(currentAsteroid);
      i--;
      puntos--;
    }
  }
}



void draw_estrellas() {
  strokeWeight(8);
  stroke(255);
  if (frameCount % frecuencia_estrellas == 0)
  {
            Estrellas myE = new Estrellas();
                 estrellas.add(myE);
  }
  for (int i = 0; i<estrellas.size(); i++)
  {
          Estrellas actual_estrella = estrellas.get(i);
              actual_estrella.drawestrellas();
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
            jugador.upPressed = true;
    } else if (keyCode == DOWN) {
              jugador.downPressed = true;
    } else if (keyCode == LEFT) {
                 jugador.leftPressed = true;
    } else if (keyCode == RIGHT) {
                      jugador.rightPressed = true;
    }
  } else if (key == ' ')
  {
         Balas b = new Balas(jugador);
           balas.add(b);
       
          
       
    
         
  }
    if (keyCode == ESC) {
             estado_de_juego  = 0; // Volver al menú principal
  }

}

void keyReleased() {
  if (keyCode == UP) {
         jugador.upPressed = false;
  } else if (keyCode == DOWN) {
           jugador.downPressed = false;
  } else if (keyCode == LEFT) {
             jugador.leftPressed = false;
  } else if (keyCode == RIGHT) {
                jugador.rightPressed = false;
  }
}

void mousePressed() {
   if (estado_de_juego  == 0 && mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 20 && mouseY < height/2 + 70) 
   {
    laser.play();
   estado_de_juego  = 1;
    player.loop(); 
  }
  
  if (Fin!= null && Fin.mouseOverButton() == true ) 
  {
    reiniciar();
  }
  
   
 
}
 
 void guardarDatos(String nombre, int puntos) {
    String[] datos = { "Nombre: " + nombre, "Puntos: " + puntos };
    saveStrings("datos.txt", datos);
  }
//void serialEvent(Serial Puerto)
//{
 // leer=Puerto.read(); //Lee datos del Arduino
//}

void reiniciar() {
  estrellas.clear();
  balas.clear();
  enemigos.clear();
  jugador = new Nave();
  Fin = null;
  puntos = 0;
  contador=0;
  player.play();
  player1.play();
  laser.play();
}
