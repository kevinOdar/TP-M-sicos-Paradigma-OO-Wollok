
class Musico {
	var habilidad
	var listaAlbumes = [ ]
	var esSolista
	var tipoCantante
	var tipoCobro

	constructor(cuantaHabilidad, solista, albumesPublicados,tipoDeCantante,tipoDeCobro) {
		habilidad = cuantaHabilidad 
		listaAlbumes = albumesPublicados 
		esSolista =	solista
		tipoCantante = tipoDeCantante
		tipoCobro = tipoDeCobro
	}
	method dejarGrupo() {
		esSolista = true
	}
	method enGrupo(){
		esSolista = false
	}
	method esMinimalista() {
		return listaAlbumes.all({ album => album.esDeDuracionCorta() })
	}

	method contieneLaPalabra(palabra) {
		return listaAlbumes.flatMap({ album => album.queCancionesContienen(palabra) })	
	}
	
	method obtenerListaDeCanciones(){
		return ( listaAlbumes.flatMap({ album => album.listarCanciones() }) )

	}
	method duracionObra() {
		return listaAlbumes.sum({ album => album.duracionTotal() })
	}
	method laPego() {
		return listaAlbumes.all({ album => album.buenasVentas() })
	}
	
	method agregarAlbum(listaDeAlbumesAAgregar) {
		listaAlbumes.add(listaDeAlbumesAAgregar)
	}
	//method interpretaBien(cancion){
	//return self.obtenerListaDeCanciones().contains(cancion) || self.habilidad() > 60
	//}
	method interpretaBien(cancion){
		return tipoCantante.interpretaBienLaCancion(self,cancion)
	}
	method transformarCantante(nuevoTipo){
		tipoCantante = nuevoTipo
	}
	method formaDeCobro(tipo){
		tipoCobro = tipo
	}
	method vaACobrar(presentacion){
		return tipoCobro.cobra(self,presentacion)
	}
	method habilidad(){
		return habilidad
	}
	method esCompositor(){
		return self.obtenerListaDeCanciones().isEmpty().negate()
	}
	method habilidadMayorA(num){
		return self.habilidad() >= num
	}
	method habilidadMenorA(num){
		return self.habilidad() <= num
	}
	method interpretaBienLasCanciones(listaDeCanciones){
		return listaDeCanciones.filter({cancion => self.interpretaBien(cancion)})
	}
	method modificarHabilidad(nuevaHabilidad){ //method necesario para correr un test del tp4, ya que necesito modificar la habilidad de kike para que funcione
		habilidad = nuevaHabilidad
	}
}

class TipoDeCantante {
	method interpretaBienLaCancion(cantante,cancion){
	return cantante.obtenerListaDeCanciones().contains(cancion) || cantante.habilidad() > 60
	}
}

class Palabrero inherits TipoDeCantante{
	var palabraClave
	constructor(palabraParaLaQueCantaBien){
		palabraClave = palabraParaLaQueCantaBien
	}
	override method interpretaBienLaCancion(cantante,cancion){
		return (super(cantante,cancion) || cancion.contiene(palabraClave))
	}
}

class Larguero inherits TipoDeCantante{
	var duracionDeCancion
	constructor(duracionDeCancionConLaQueCantaBien){
		duracionDeCancion = duracionDeCancionConLaQueCantaBien
	}
	override method interpretaBienLaCancion(cantante,cancion){
		return (super(cantante,cancion) || cancion.duracion() > duracionDeCancion)
	}
}

object imparero inherits TipoDeCantante{
	override method interpretaBienLaCancion(cantante,cancion){
		return (super(cantante,cancion) || cancion.duracion().odd())
	}
}
/* 
 * NO ES NECESARIA DEBIDO A QUE SE MODIFICARON LOS METODOS DENTRO DE luisAlberto
object unicoEIrrepetible inherits TipoDeCantante{
	override method interpretaBienLaCancion(cantante,cancion){
		return true
	}
}


object cobroDelUnicoEIrrepetible {
	method cobra(cantante,presentacion) {
		if (self.esLuegoDeFechaTope(presentacion)) {
			return 1200 }
		else { return 1000 }
	}

	method esLuegoDeFechaTope(presentacion) {
		return presentacion.fecha().month() >= 9 && presentacion.fecha().year() >=
		2017
	}
}
*/
class TipoDeCobro{
	var cantidadDeDineroBase
	constructor(cantidadDeDinero){
		cantidadDeDineroBase = cantidadDeDinero
	}
}
class CobroPorCantarSoloOConAlguien inherits TipoDeCobro{
	method cobra(cantante,presentacion){
		if (presentacion.unicoCantante(cantante)){
			return cantidadDeDineroBase
		}
		else {
			return cantidadDeDineroBase/2
		}
	}
}

class CobroPorCapacidad inherits TipoDeCobro{
	var capacidadMayorA
	var dia
	var mes
	var anio
	constructor(cantidadDeDinero,capacidad,_dia,_mes,_anio) = super(cantidadDeDinero){
		capacidadMayorA = capacidad
		dia = _dia
		mes = _mes
		anio = _anio
		}
	method cobra(cantante,presentacion){
		if (presentacion.capacidadLugar(dia,mes,anio) > capacidadMayorA){
			return cantidadDeDineroBase
		}
		else{
			return cantidadDeDineroBase-100
		}
	}
}

class CobroPorInflacion inherits TipoDeCobro{
	var ddia
	var mmes
	var aanio
	var porcentajeAdicionalCobrado
	constructor(cantidadDeDinero,dia,mes,anio,porcentajeAdicional) = super(cantidadDeDinero){
		ddia = dia
		mmes = mes
		aanio = anio
		porcentajeAdicionalCobrado = porcentajeAdicional
	}
	method cobra(cantante,presentacion){
		if (presentacion.fecha() < new Date(ddia,mmes,aanio)){
			return cantidadDeDineroBase
		}
		else {
			return cantidadDeDineroBase * (1+porcentajeAdicionalCobrado)
		}
	}
}

class MusicoDeGrupo inherits Musico {
	var aumentaEnGrupo

	constructor(cuantaHabilidad, solista, albumesPublicados, tipoDeCantante, tipoDeCobro, cantidadQueAumentaEnGrupo) =
	super ( cuantaHabilidad , solista , albumesPublicados, tipoDeCantante, tipoDeCobro ) {
		aumentaEnGrupo = cantidadQueAumentaEnGrupo
	}
	override method habilidad() {
		if (esSolista) {
			return habilidad
		}
		else {
			return habilidad + aumentaEnGrupo
		}
	}
}

class VocalistaPopular inherits Musico {
	override method habilidad() {
		if (esSolista) {
			return habilidad
		}
		else {
			return habilidad - 20
		}
	}
}

object luisAlberto inherits Musico ( 8 , true , [ ] , "", "") {
	var guitarra = gibson
	
	override method habilidad() {
		return 100.min(guitarra.unidades() * 8)
	}
	method guitarra(unaGuitarra) {
		guitarra = unaGuitarra
	}
	override method interpretaBien(cancion){
		return true
	}
	override method vaACobrar(presentacion){
		if (self.esLuegoDeFechaTope(presentacion)) {
			return 1200 }
		else { return 1000 }
	}
	method esLuegoDeFechaTope(presentacion) {
		return presentacion.fecha().month() >= 9 && presentacion.fecha().year() >=
		2017
	}
}

object gibson {
	var estaRota = false
	method unidades() {
		return if (estaRota) return 5 else 15
	}
	method cambiarARota() {
		estaRota = true
	}

	method cambiarASana() {
		estaRota = false
	}
}

object fender {

	method unidades() {
		return 10
	}
}

class Banda {
	var integrantes = []
	var discosEditados = []
	var representante
	constructor(integrantesDeBanda,discosEditadosPorLaBanda,representanteDeLaBanda){
		integrantes = integrantesDeBanda
		discosEditados = discosEditadosPorLaBanda
		representante = representanteDeLaBanda
		
	}
	method integrantes(){
		return integrantes
	}
	method discosEditados(){
		return discosEditados
	}
	method habilidad(){
		return integrantes.sum({integrante => integrante.habilidad()})*1.1
	}
	method vaACobrar(presentacion){
		return integrantes.sum({integrante => integrante.vaACobrar(presentacion)}) + representante.cobra()
	}
	method puedeTocar(cancion){
		return integrantes.all({integrante => integrante.interpretaBien(cancion)})
	}
}

class Representante{
	var importeDelCobroPorPresentacion
	constructor(cobraPorPresentancion){
		importeDelCobroPorPresentacion = cobraPorPresentancion
	}
	method cobra(){
		return importeDelCobroPorPresentacion
	}
		
}

class Album {
	var listaDeCanciones = [ ]
	var titulo
	var fechaLanzamiento
	var unidades
	var unidadesVendidas

	constructor(canciones, tituloDisco,dia,mes,anio, unidadesQueSalieron, unidadesQueSeVendieron) {
		listaDeCanciones = canciones 
		fechaLanzamiento = new Date(dia,mes,anio)
		 titulo = tituloDisco
		unidades = unidadesQueSalieron
		unidadesVendidas = unidadesQueSeVendieron
	}
	method listarCanciones() {
		return listaDeCanciones
	}

	method esDeDuracionCorta() {
		return listaDeCanciones.all({ cancion => cancion.esCorta() })
	}
	method cancionConLaDuracionMasLarga() { //sirve para el punto1 del tp3
		return listaDeCanciones.max({ cancion => cancion.longitud() })
	}
	method buenasVentas() {
		return unidadesVendidas >= 0.75 * unidades
	}
	method queCancionesContienen(palabra) {
		return listaDeCanciones.filter({ cancion => cancion.contiene(palabra) })
	}
	method duracionTotal() {
		return listaDeCanciones.sum({ cancion => cancion.duracion() })
	}
	method cancionConTamanioDeLetraMasLargo(){
		return self.mayorSegun({cancion => cancion.longitud()})
	}
	method tituloMasLargo(){
		return listaDeCanciones.max({cancion => cancion.longitudTitulo()})
	}
	method mayorSegun(criterioBloque){
		return listaDeCanciones.max(criterioBloque)		
	}
}

class Cancion {
	var nombre
	var duracion
	var letra

	constructor(nombreCancion, duracionCancion, letraCancion) {
		nombre = nombreCancion duracion = duracionCancion letra = letraCancion
	}
	method nombre(){
		return nombre
	}
	method duracion() {
		return duracion
	}
	method letra() {
		return letra
	}
	method contiene(palabra) {
		return letra.contains(palabra)
	}
	method longitud() {
		return letra.size()
	}
	method longitudTitulo() {
		return nombre.size()
		}
	method esCorta() {
		return duracion < 180
	}
}

class Remix inherits Cancion{
	constructor(nombreCancion, duracionCancion, letraCancion) = super (nombreCancion, duracionCancion, letraCancion){
		duracion = duracionCancion*3
		letra = "mueve tu cuelpo baby "+letraCancion+" yeah oh yeah"
	}
}

class Mashup inherits Cancion{
	constructor(nombreCancion, duracionCancion, letraCancion, nombreCancion2, duracionCancion2, letraCancion2) = super (nombreCancion, duracionCancion, letraCancion){
		nombre = nombreCancion + " " + nombreCancion2
		duracion = duracionCancion.max(duracionCancion2)
		letra = letraCancion + " " + letraCancion2
	}
}	

class MashupTest{ //revisar
	var nombre
	var duracion
	var letra
	var listaCanciones = []
	constructor(listaDeCanciones){
		listaCanciones = listaDeCanciones
		
		nombre = self.nombreMashup(listaDeCanciones)
		duracion = listaCanciones.max({cancion => cancion.duracion()})
		letra = self.letraMashup(listaDeCanciones)
		}
	
	method nombreMashup(listaDeCanciones){
		return listaDeCanciones.map({cancion => cancion.nombre()}).fold("",{nombre1,nombre2 => nombre1 + " "+ nombre2}).trim()
	}
	
	method letraMashup(listaDeCanciones){
		return listaDeCanciones.map({cancion => cancion.letra()}).fold("",{letra1,letra2 => letra1+" "+letra2}).trim()
	
	}
	method nombre(){
		return nombre
	}
	method duracion() {
		return duracion
	}
	method letra() {
		return letra
	}
}

object lunaPark {
	var capacidad = 9290
	method capacidad(dia, mes, anio) {
		return capacidad
	}
	method concurrido() {
		return capacidad > 5000
	}
}

object laTrastienda {
	var capacidad = 400
	
	method esSabado(dia, mes, anio) {
		var unDia
		unDia = new Date(dia, mes, anio) return unDia.dayOfWeek() == 6
	}
	method capacidad(dia, mes, anio) {
		if (self.esSabado(dia, mes, anio)) return capacidad + 300 return capacidad
	}
	method concurrido() {
		return capacidad > 5000
	}
}

object prixDami{
	method capacidad(dia, mes, anio){
		return 150
	}
}

object laCueva{
	method capacidad(dia, mes, anio){
		return 14000
	}
}

class Presentacion {
	var lugar
	var cantantes = []
	var fechaDePresentacion
	method modificarFecha(dia, mes, anio) {
		fechaDePresentacion = new Date(dia, mes, anio)
	}
	method capacidadLugar(dia, mes, anio){
		return lugar.capacidad(dia, mes, anio)
	}
	method modificarLugar(nuevoLugar) {
		lugar = nuevoLugar
	}
	method modificarCantantes(listaCantantes) {
		cantantes = listaCantantes
	}
	method esEnLugarConcurrido() {
		return lugar.concurrido()
	}
	method fecha() {
		return fechaDePresentacion
	}
	method unicoCantante(cantanteABuscar){
		return (cantantes.any({cantante => cantante == cantanteABuscar}) and cantantes.size() == 1)
	}
	method magia(){
		return cantantes.sum({cantante => cantante.habilidad()})
	}
	method cuantoVaAPagar(){
		return cantantes.sum({cantante => cantante.vaACobrar(self)})
	}
}

class PresentacionConRestricciones inherits Presentacion{
	var cancionAlicia = new Cancion("Canci�n de Alicia en el pa�s",510,"Qui�n sabe Alicia, este pa�s no estuvo hecho porque s�. Te vas a ir, vas a salir pero te quedas, �d�nde m�s vas a ir? Y es que aqu�, sabes el trabalenguas, trabalenguas, el asesino te asesina, y es mucho para ti. Se acab� ese juego que te hac�a feliz.")
	method cantanteConHabilidadMayorAlMinimo(cantante){
		return cantante.habilidadMayorA(70)
	}
	method cantanteDebeSerCompositor(cantante){
		return cantante.esCompositor() 
	}
	method cantanteDebeInterpretarBienLaCancion(cantante,cancion){
		return cantante.interpretaBien(cancion)
	}
	method agregarUnCantante(cantante){
		if (self.cantanteConHabilidadMayorAlMinimo(cantante) && self.cantanteDebeSerCompositor(cantante) && self.cantanteDebeInterpretarBienLaCancion(cantante,cancionAlicia)){
			cantantes.add(cantante)	
		}
		else{
			if (not (self.cantanteConHabilidadMayorAlMinimo(cantante))) {error.throwWithMessage("El cantante no cumple con la habilidad minima de 70!!")}
			if (not (self.cantanteDebeSerCompositor(cantante))) {error.throwWithMessage("El cantante no es compositor!!")}
			else {error.throwWithMessage ("El cantante no interpreta la cancion Alicia!!")}
		}	
	}
	method cantantesAceptados(){
		return cantantes
	}
	
}

//Punto Bonus
class PresentacionRestringida inherits Presentacion{
	var listaDeCondiciones = []
	method agregarCondiciones(condicion){
		listaDeCondiciones.add(condicion)
	}
	method eleminarCondiciones(condicion){
		listaDeCondiciones.remove(condicion)
	}
	method agregarUnCantante(cantante){
		if (listaDeCondiciones.all({condicion => condicion.seCumple(cantante)})){
			cantantes.add(cantante)
		}
	}
	method condicionesVigentes(){
		return listaDeCondiciones
	}
	method cantantesAceptados(){
		return cantantes
	}
}

class CondicionHabilidadMayorA{
	var habilidad
	constructor(habilidadAEvaluar) {
		habilidad = habilidadAEvaluar
	}
	method seCumple(cantante){
		if(cantante.habilidadMayorA(habilidad))
		{return true}
		else
		{error.throwWithMessage("La habilidad debe ser mayor a " + habilidad)
			return false
		}
	}
}

class CondicionHabilidadMenorA{
	var habilidad
	constructor(habilidadAEvaluar) {
		habilidad = habilidadAEvaluar
	}
	method seCumple(cantante){
		return cantante.habilidadMenorA(habilidad)	
	}
}

class CondicionDebeSerCompositor{
	var esONoCompositor
	constructor(booleanoElegido) {
		esONoCompositor = booleanoElegido
	}
	method seCumple(cantante){
		if ((esONoCompositor and cantante.esCompositor())
			or
			(esONoCompositor.negate() and cantante.esCompositor().negate())
		)
		{
			return true
		}
		else {
			error.throwWithMessage("El cantante no cumple con el requisito de ser o no compositor")
			return false
		}	
	}
}

class CondicionSabeInterpretar{
	var cancion
	constructor(cancionADefinir) {
		cancion = cancionADefinir
	}
	method seCumple(cantante){
		if(cantante.interpretaBien(cancion)){
		return true
		}
		else{
		error.throwWithMessage("El cantante no interpreta " + cancion.nombre() + "!!")
		return false
		}
	}
}