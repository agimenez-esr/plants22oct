import { LightningElement, wire, track } from 'lwc';
import fetchGasPrices from '@salesforce/apex/ApiConnectGas.fetchGasPrices';
import fetchMunicipios from '@salesforce/apex/ApiConnectGas.fetchMunicipios';


export default class GasTile extends LightningElement {
    gasPricesWithIndex;
    error;

    @wire(fetchGasPrices)
    wiredResult(result) {
        if (result.data) {
            let results = JSON.parse(result.data);
            results.sort((a, b) => {
                let priceA = parseFloat(a.Precio_Gasoleo_A.replace(',', ''));
                let priceB = parseFloat(b.Precio_Gasoleo_A.replace(',', ''));
                return priceA - priceB;
            });

            this.gasPricesWithIndex = results.map((price, index) => ({
                ...price,
                _uniqueKey: 'key-' + index
            }));
            this.renderGasPrices();
        } else if (result.error) {
            this.error = result.error;
        }
    }

    renderGasPrices() {
        const container = this.template.querySelector('.gasPricesContainer');
        while (container.firstChild) {
            container.removeChild(container.firstChild);
        }

        this.gasPricesWithIndex.forEach(station => {
            const div = document.createElement('div');
            console.log(station, '************************************');
            div.innerHTML = `
                <p><strong>Dirección:</strong> ${station.Direccion}</p>
                <p><strong>Municipio:</strong> ${station.Municipio}</p>
                <p><strong>Rótulo:</strong> ${station.Rotulo}</p>
                <p><strong>Precio Gasoleo A:</strong> ${station.Precio_Gasoleo_A}</p>
                <p><strong>Precio Gasolina 95:</strong> ${station.Precio_Gasolina_95}</p>
            `;
            container.appendChild(div);
        });
    }

    @track selectedOptionprov;
    optionsprov = [
        { label: 'CASTELLÓN', value: '12' },
        { label: 'VALENCIA', value: '46' },
        { label: 'ALICANTE', value: '03' }
    ];

    @track selectedOption;
    options = [
        { label: 'PATERNA', value: '7149' },
        { label: 'SAGUNTO', value: '7183' },
        { label: 'BENETUSER', value: '7019' },
        { label: 'RIBARROJA', value: '7177' },
        { label: 'PAIPORTA', value: '7145' },
        { label: 'MONCADA', value: '7130' },
        { label: 'ALFARA DEL PATRIARCA', value: '6989' },
        { label: 'MANISES', value: '7118' }
    ];

    handleSelectionChange(event) {
        this.selectedOption = event.detail.value;
        fetchGasPrices({ municipioCode: this.selectedOption })
            .then(data => {
                let results = JSON.parse(data);
                results.sort((a, b) => {
                    let priceA = parseFloat(a.Precio_Gasoleo_A.replace(',', ''));
                    let priceB = parseFloat(b.Precio_Gasoleo_A.replace(',', ''));
                    return priceA - priceB;
                });

                this.gasPricesWithIndex = results.map((price, index) => ({
                    ...price,
                    _uniqueKey: 'key-' + index
                }));

                this.renderGasPrices();
            })
            .catch(error => {
                this.error = error;
            });
    }   
}
