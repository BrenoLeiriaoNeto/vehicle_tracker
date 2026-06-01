import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';
import 'package:vehicle_tracker/src/features/garage/state/add_vehicle_state.dart';

class AddVechileController extends Ion<AddVehicleState> {
  final GetBrandsUseCase _getBrandsUseCase;
  final GetModelsUseCase _getModelsUseCase;
  final SaveVehicleUseCase _saveVehicleUseCase;

  AddVechileController(
    this._getBrandsUseCase,
    this._getModelsUseCase,
    this._saveVehicleUseCase,
  ) : super(AddVehicleState.initial());

  Future<void> loadBrands() async {
    set(state.copyWith(status: .loading));

    try {
      final brands = await _getBrandsUseCase();
      set(state.copyWith(status: .success, brands: brands));
    } catch (e) {
      set(
        state.copyWith(
          status: .error,
          errorMessage: 'Falha ao buscar marcas: $e',
        ),
      );
    }
  }

  Future<void> selectBrand(FipeItem brand) async {
    set(
      state.copyWith(
        selectedBrand: brand,
        status: .loading,
        clearModel: true,
        clearYear: true,
        models: [],
        years: [],
      ),
    );

    try {
      final models = await _getModelsUseCase(brand.codigo);
      set(state.copyWith(status: .initial, models: models));
    } catch (e) {
      set(
        state.copyWith(
          status: .error,
          errorMessage: 'Falha ao buscar modelos: $e',
        ),
      );
    }
  }

  void selectModel(FipeItem model) {
    set(
      state.copyWith(
        selectedModel: model,
        selectedYear: const FipeItem(codigo: '2026-3', nome: '2026 Gasolina'),
      ),
    );
  }

  Future<bool> submitVehicle({
    required String plate,
    required double currentKm,
  }) async {
    if (state.selectedBrand == null ||
        state.selectedModel == null ||
        plate.isEmpty) {
      set(
        state.copyWith(
          status: .error,
          errorMessage: 'Preencha todos os dados obrigatórios!',
        ),
      );
      return false;
    }

    set(state.copyWith(status: .loading));

    try {
      final newVehicle = Vehicle(
        plate: plate.toUpperCase().trim(),
        brand: state.selectedBrand!.nome,
        model: state.selectedModel!.nome,
        year: state.selectedYear?.nome ?? 'Ano Desconecido',
        currentKm: currentKm.toString(),
        status: 'available',
      );

      await _saveVehicleUseCase(newVehicle);
      set(state.copyWith(status: .success));
      return true;
    } catch (e) {
      set(
        state.copyWith(
          status: .error,
          errorMessage: 'Erro ao salvar no Firestore: $e',
        ),
      );
      return false;
    }
  }
}
