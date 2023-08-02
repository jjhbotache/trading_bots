// comentario de una linea
/* 
comentario de varias lineas
// nested comment
 */

bool boleano = false;
int entero = 1;
double decimal = 1.1;
string cadena = "hola mundo";
datetime fecha = D'2021.01.01 00:00';
color Color = clrRed;
enum Enumeracion {valor1, valor2, valor3};


class Carro{
  private:
  public:
    int ruedas;

    Carro(int r = 4){
        Print("Soy un carro: "+ r );
        ruedas = r;
    }

    void avanzar(){
      Print("avanzando");
    }
};


int OnInit(){
  Print("hola mundo");
  Carro carro(6); 
  Print(carro.ruedas);
  carro.avanzar();
  return(1);
}