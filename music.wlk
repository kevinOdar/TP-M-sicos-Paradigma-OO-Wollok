object joaquin {
	var cobra = 50
	var habilidad = 25
	
	method habilidad(){
		return habilidad
	}
	method dejarGrupo(){
		habilidad = 20
		cobra = 100
	}
	
	method incorporarseAGrupo(){
		habilidad = 25
		cobra = 50
	}	
	
	method interpretaBien(cancion){
		return cancion.duracion()> 300
	}
	method cobra(presentacion){
		return cobra
	}
}

object lucia{
	var cobraComoBase = 400
	var habilidad = 50 
	method esIntegrante(){
		return pimpinela
	}
	method habilidad(){
		return habilidad
	}
	method dejarGrupo(){
		habilidad += 20
	}
	method interpretaBien(cancion){
		return cancion.letra().contains("familia")
	}
	
	method cobra(presentacion){
		if(presentacion.esEnLugarConcurrido()){
			return 500
		}
		else{
		return cobraComoBase
		}
	}
}

object luisAlberto{
	
	var guitarra = gibson

	method habilidad(){
		return 100.min(guitarra.unidades() * 8)
		}
	method interpretaBien(cancion){
		return true
	}
	method cobra(presentacion){
		if (presentacion.fecha().month() >= 9 && presentacion.fecha().year() >= 2017){
		return 1200}
		else{return 1000}
		
		}
		
	method guitarra(unaGuitarra){
		guitarra = unaGuitarra
	}
	}

class Cancion{
	var nombre
	var duracion
	var letra
	method modificarNombre(nuevoNombre){
		nombre = nuevoNombre
	}
	method modificarDuracion(nuevaDuracion){
		duracion = nuevaDuracion
	}
	method modificarLetra(nuevaLetra){
		letra = nuevaLetra
	}
	method duracion(){
		return duracion
	}
	method letra(){
		return letra
	}
	
} 

object lunaPark{
	var capacidad = 9290
	method capacidad(dia,mes,anio){
	return capacidad 	
	}
	method concurrido(){
		return capacidad >5000
	}
}

object laTrastienda{
	var capacidad = 400
	method esSabado(dia,mes,anio){
		var unDia = new Date(dia,mes,anio)
		return unDia.dayOfWeek() == 6
		
	}
	method capacidad(dia,mes,anio){
		if (self.esSabado(dia,mes,anio)) return capacidad + 300 
		return capacidad
	}
	method concurrido(){
		return capacidad >5000
	}
}

class Presentacion{
	var lugar
	var cantantes
	var fechaDePresentacion
	method modificarFecha(dia,mes,anio){
		fechaDePresentacion = new Date(dia,mes,anio)
	}
	method modificarLugar(nuevoLugar){
		lugar = nuevoLugar
	}
	method modificarCantantes(listaCantantes){
		cantantes = listaCantantes
	}
	method esEnLugarConcurrido(){
		return lugar.concurrido()
	}
	method costo(){
		return cantantes.sum({cantante => cantante.cobra(self)})
	}
	method esEnSeptiembre(){
		return fechaDePresentacion.month() == 9
	}
	method fecha(){
		return fechaDePresentacion
	}
}

object pimpinela{}
object gibson{
	
	var estaRota = false
	method unidades(){
		return if(estaRota) return 5 else 15
	}
	method cambiarARota(){
		estaRota = true
	}
	
	method cambiarASana(){
		estaRota = false
	}
}

object fender{
	
	method unidades(){
		return 10
	}
}
