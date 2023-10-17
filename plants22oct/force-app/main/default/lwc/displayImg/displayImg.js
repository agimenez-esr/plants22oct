import { LightningElement, api } from 'lwc';

export default class DisplayImg extends LightningElement {
    @api url;
    @api height;
    @api width;
}