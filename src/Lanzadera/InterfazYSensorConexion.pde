//void reintentarConexion

void oscStatus(OscStatus estado) {
  println(estado);
  oscStatus(estado.id());
}
void oscStatus(int estado) {
  if (estado != OscStatus.DEFAULT && estado != OscStatus.SEND_FAILED && estado != OscStatus.OSCP5_CLOSED) {
    println("algun problema de conexion: "+estado);
  }
}

class InterfazYSensorConexion implements AutoDraw {
  TwOutQuad animacion;
  TwInOutBack tweenPanel;
  PImage iconoConexion;
  //String iconoConexion;
  boolean visible = false;// Esto debe ser true si al menos hay uno de los modulos desactivados

  boolean reintantando;
  final String ipLocalHost = "127.0.0.1";

  String ipCarrete = ipLocalHost, ipObservador = ipLocalHost, ipLienzo = ipLocalHost;
  String portCarrete = "12000", portObservador = "11000", portLienzo = "10000";
  float tamPanelInferior = 180;
  CampoIP lienzo, observador, carrete;
  float[] posYBase;
  float anchoCampoIP = 300, altoCampoIP = 30;

  BotonBasico mas, menos;
  PVector ejeMasMenos;

  InterfazYSensorConexion() {
    autoDraw.add(this);
    iconoConexion = iconos.get(dicIcos.conexion);
    //if (this.iconoConexion == null) this.iconoConexion = iconos.iconoVacio();
    animacion = (TwOutQuad)(new TwOutQuad()).inicializar(0.5f);
    tweenPanel = (TwInOutBack)(new TwInOutBack()).inicializar(.7);

    ejeMasMenos = new PVector(width + tamPanelInferior/2, height-tamPanelInferior/2, tamPanelInferior);
    mas = new BotonBasico( ejeMasMenos.x - ejeMasMenos.z, ejeMasMenos.y, 0, dicIcos.mas, paleta.panelSuperior );
    menos = new BotonBasico( ejeMasMenos.x, ejeMasMenos.y + ejeMasMenos.z, HALF_PI, dicIcos.menos, paleta.fondo );
    mas.escala = menos.escala = (tamPanelInferior-90)/mas.icono.height;

    float xBase = width/2-anchoCampoIP/2;
    posYBase = new float[]{ tamPanelInferior/2-altoCampoIP*2, tamPanelInferior/2-altoCampoIP*.5, tamPanelInferior/2+altoCampoIP*1 };
    lienzo = new CampoIP(xBase, posYBase[0], anchoCampoIP, altoCampoIP, paleta.ips[0]);
    observador = new CampoIP(xBase, posYBase[1], anchoCampoIP, altoCampoIP, paleta.ips[1]);
    carrete = new CampoIP(xBase, posYBase[2], anchoCampoIP, altoCampoIP, paleta.ips[2]);
  }
  void draw() {
    boolean sinConexion = oscTester.ip().equals(ipLocalHost);
    pushStyle();
    //if (sinConexion)
    {

      fill(255, 0, 0);
      textAlign(LEFT, TOP);
      textSize(16);
      text("Sin Conexion (posiblemente)", 12, 8);
    }
    popStyle();
    panelInferior();

    observador.col = (lienzo.ip .equals( observador.ip) ) ? paleta.ips[0] : paleta.ips[1];
    carrete.col = (observador.ip .equals( carrete.ip) ) ? observador.col : (lienzo.ip .equals( carrete.ip) ) ? lienzo.col : paleta.ips[2];
  }

  void panelInferior() {
    tweenPanel.actualizar(visible?dt:-dt);

    menos.pos.z = tweenPanel.valor()*HALF_PI+HALF_PI;
    mas.pos.z = menos.pos.z+HALF_PI;
    menos.pos.set(ejeMasMenos.x+ejeMasMenos.z*cos(menos.pos.z), ejeMasMenos.y+ejeMasMenos.z*sin(menos.pos.z));
    mas.pos.set(ejeMasMenos.x+ejeMasMenos.z*cos(mas.pos.z), ejeMasMenos.y+ejeMasMenos.z*sin(mas.pos.z));
    if (menos.presionado || mas.presionado) {
      visible = !visible;
    }

    float offsetPanel = height-tweenPanel.valor()*tamPanelInferior;

    pushStyle();
    pushMatrix();
    noStroke();
    fill(paleta.panelSuperior);
    translate(0, offsetPanel);
    rect(0, 0, width, tamPanelInferior*2);
    popMatrix();
    popStyle();

    lienzo.pos.y = posYBase[0]+offsetPanel;
    observador.pos.y = posYBase[1]+offsetPanel;
    carrete.pos.y = posYBase[2]+offsetPanel;
  }
}