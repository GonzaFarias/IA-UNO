% Ciudades, distancias, tiempos y costos
ciudades(capital_federal, chascomus, 2, 2, 0).
ciudades(chascomus, dolores, 2, 2, 5).
ciudades(dolores, maipu, 2, 2, 0).
ciudades(maipu, mar_del_plata, 2, 2, 0).
ciudades(dolores, conesa, 63, 60, 0).
ciudades(conesa, costa_azul, 11, 12, 5).
ciudades(costa_azul, pinamar, 11, 12, 0).
ciudades(pinamar, mar_del_plata, 11, 12, 0).

% Peaje en las ciudades
peaje(dolores).
peaje(costa_azul).

% Predicado principal del viaje
viajar(Destino, Destino, _, _, _, _, [], [], Camino, Acciones) :- 
    write('Llegamos a destino: '), write(Destino), nl,
    write('Ruta final: '), write(Camino), nl,
    write('Acciones realizadas: '), write(Acciones), nl.

viajar(CiudadActual, Destino, Vehiculo, PasajerosTotales, CombustibleTotal, PresupuestoTotal, [Parada|Restantes], [PasajerosAbajar|RestantesPasajeros], [CiudadActual|Camino], Acciones) :-
    ciudades(CiudadActual, NuevaCiudad, Distancia, _, CostoPeaje),
    calcular_combustible(CombustibleTotal, Distancia, NuevoCombustible),
    calcular_costo(PresupuestoTotal, CostoPeaje, NuevoPresupuesto),
    
    % Manejar peaje y paradas
    (   peaje(CiudadActual) -> 
        frenar, 
        pagar_peaje(CostoPeaje),
        abrir_puertas(CiudadActual),
        bajar_pasajeros(PasajerosAbajar),
        cerrar_puertas(CiudadActual),
        arrancar
    ;   true
    ),
    
    % Verificar si hay que bajar pasajeros
    (   Parada = CiudadActual -> 
        bajar_pasajeros(PasajerosAbajar),
        NuevoTotal is PasajerosTotales - PasajerosAbajar
    ;   NuevoTotal is PasajerosTotales
    ),

    % Verificar si hay suficiente combustible y presupuesto para continuar
    (   NuevoCombustible >= 0, NuevoPresupuesto >= 0 ->
        write('Avanzando hacia '), write(NuevaCiudad), write(' con combustible restante: '), write(NuevoCombustible), nl,
        viajar(NuevaCiudad, Destino, Vehiculo, NuevoTotal, NuevoCombustible, NuevoPresupuesto, Restantes, RestantesPasajeros, [NuevaCiudad|Camino], [avanzar|Acciones])
    ;   (NuevoCombustible < 0 -> write('No hay suficiente combustible.'), nl
        ;   write('No hay suficiente presupuesto.'), nl),
        fail
    ).

% Acciones del bondi
frenar :- write('Micro frenado (velocidad 0).'), nl.
abrir_puertas(Ciudad) :- write('Abriendo puertas en '), write(Ciudad), nl.
cerrar_puertas(Ciudad) :- write('Cerrando puertas en '), write(Ciudad), nl.
arrancar :- write('Micro arrancando (acelerado).'), nl.
bajar_pasajeros(Cantidad) :- write('Bajando '), write(Cantidad), write(' pasajeros.'), nl.
pagar_peaje(Costo) :- write('Pagando peaje de '), write(Costo), write(' unidades.'), nl.

% Calculos
calcular_combustible(CombustibleTotal, Distancia, NuevoCombustible) :- 
    ConsumoPorKm is 0.1,
    NuevoCombustible is CombustibleTotal - (Distancia * ConsumoPorKm).

calcular_costo(PresupuestoTotal, CostoPeaje, NuevoPresupuesto) :- 
    NuevoPresupuesto is PresupuestoTotal - CostoPeaje.
