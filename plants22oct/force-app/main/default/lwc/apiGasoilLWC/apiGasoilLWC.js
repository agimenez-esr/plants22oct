import { LightningElement } from 'lwc';

export default class ApiGasoilLWC extends LightningElement {
    async connectedCallback() {
        // Realizar la llamada GET a la URL
        try {
            const response = await fetch('https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/FiltroProvincia/02');

            if (response.ok) {
                // Si la respuesta es exitosa, parsea la respuesta JSON
                const data = await response.json();
                console.log(data); // Esto imprimirá la respuesta en la consola
            } else {
                console.error('Error al obtener los datos');
            }
        } catch (error) {
            console.error('Error en la llamada GET', error);
        }
    }
}
