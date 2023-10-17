import { LightningElement, api } from 'lwc';

export default class SpeciesTile extends LightningElement {
    @api specie;
    isModalOpen = false;

    handleViewMoreClick() {
        if (!this.isModalOpen) { // Verificar si el modal no está abierto
            this.isModalOpen = true;
        }
    }
    
    closeModal() {
        if (this.isModalOpen) { // Verificar si el modal está abierto
            this.isModalOpen = false;
        }
    }
}
