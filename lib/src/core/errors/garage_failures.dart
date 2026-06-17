abstract class GarageFailure implements Exception {
  final String message;

  const GarageFailure(this.message);

  @override
  String toString() => message;
}

class FipeNetworkFailure extends GarageFailure {
  const FipeNetworkFailure([
    super.message =
        'Não foi possível conectar à API da FIPE. Verifique sua conexão.',
  ]);
}

class FipeDataParsingFailure extends GarageFailure {
  const FipeDataParsingFailure([
    super.message =
        'Ocorreu um erro ao processar os dados dos veículos da FIPE.',
  ]);
}

class GarageStorageFailure extends GarageFailure {
  const GarageStorageFailure([
    super.message =
        'Falha ao salvar ou ler os dados da garagem no banco de dados.',
  ]);
}

class VehicleNotFoundFailure extends GarageFailure {
  const VehicleNotFoundFailure() : super('Veículo não encontrado na garagem.');
}

class UnknownGarageFailure extends GarageFailure {
  const UnknownGarageFailure([
    super.message = 'Ocorreu um erro inesperado na sua garagem.',
  ]);
}
