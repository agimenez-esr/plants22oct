public with sharing class InvocableDeleteSpecies {
    
    @InvocableMethod(label='Eliminar Especie' description='Elimina una especie por nombre')
    public static void deleteSpecies(List<DeleteSpeciesInput> inputList) {
        DeleteSpecies.DeleteSpecies(inputList[0].Deleter);
    }

    public class DeleteSpeciesInput {
        @InvocableVariable(label='Nombre de la Especie' description='Nombre de la especie a eliminar')
        public String Deleter;
    }
}
