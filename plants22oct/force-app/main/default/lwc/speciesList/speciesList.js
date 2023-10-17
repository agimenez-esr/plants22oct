import { LightningElement, wire } from 'lwc';
import getAllSpecies from '@salesforce/apex/SpeciesService.getAllSpecies';

export default class SpeciesList extends LightningElement {
    @wire(getAllSpecies) mySpecies;

    //mySpecies.data --> datos devueltos por apex
    //mySpecies.error --> si hay un error, ahí se almacena
    

}