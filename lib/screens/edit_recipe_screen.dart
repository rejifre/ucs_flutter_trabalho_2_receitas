// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/ingredient_model.dart';
import '../models/instruction_model.dart';
import '../models/recipe_model.dart';
import '../providers/recipes_provider.dart';
import '../routes/routes.dart';
import '../ui/app_colors.dart';
import '../ui/recipe_screen_type.dart';
import 'widgets/edit_form_ingredient_list_widget.dart';
import 'widgets/edit_form_instruction_list_widget.dart';

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({super.key});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<EditFormIngredientListWidgetState> _ingredientListKey =
      GlobalKey<EditFormIngredientListWidgetState>();
  final GlobalKey<EditFormInstructionListWidgetState> _instructionListKey =
      GlobalKey<EditFormInstructionListWidgetState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _preparationTimeController =
      TextEditingController();

  final _uuid = const Uuid();

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _scoreController.dispose();
    _preparationTimeController.dispose();
    super.dispose();
  }

  void _confirmDeleteRecipe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text(
            'Tem certeza de que deseja excluir esta receita?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Deletar'),
              onPressed: () async {
                final provider = Provider.of<RecipesProvider>(
                  context,
                  listen: false,
                );
                Navigator.popUntil(context, ModalRoute.withName(Routes.home));
                await provider.deleteRecipe(_idController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<RecipesProvider>(context, listen: false);
      _formKey.currentState!.save();

      final ingredientControllers = _ingredientListKey.currentState!;
      final instructionControllers = _instructionListKey.currentState!;

      final ingredients = List.generate(
        ingredientControllers.ingredientNameControllers.length,
        (i) => Ingredient(
          id: ingredientControllers.ingredientIds[i],
          name: ingredientControllers.ingredientNameControllers[i].text,
          quantity: ingredientControllers.ingredientQuantityControllers[i].text,
          recipeId: _idController.text,
        ),
      );

      final instructions = List.generate(
        instructionControllers.instructionDescriptionControllers.length,
        (i) => Instruction(
          id: instructionControllers.instructionIds[i],
          stepOrder: i + 1,
          description:
              instructionControllers.instructionDescriptionControllers[i].text,
          recipeId: _idController.text,
        ),
      );

      final updatedRecipe = Recipe(
        id: _idController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        score: double.parse(_scoreController.text),
        preparationTime: _preparationTimeController.text,
        ingredients: ingredients,
        steps: instructions,
        date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      );
      final sm = ScaffoldMessenger.of(context);
      provider.addOrUpdateRecipe(updatedRecipe);

      sm.showSnackBar(
        const SnackBar(
          content: Text("Receita Salva."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Recipe? currentRecipe =
        ModalRoute.of(context)?.settings.arguments as Recipe?;
    final isEditing = currentRecipe != null && currentRecipe.title.isNotEmpty;

    _idController.text = currentRecipe?.id ?? _uuid.v4().toString();
    _titleController.text = currentRecipe?.title ?? '';
    _descriptionController.text = currentRecipe?.description ?? '';
    _scoreController.text = currentRecipe?.score.toString() ?? '';
    _preparationTimeController.text = currentRecipe?.preparationTime ?? '0h 0m';
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? RecipeScreenType.editRecipe : RecipeScreenType.newRecipe,
        ),
        actions: <Widget>[
          Visibility(
            visible: isEditing,
            child: TextButton.icon(
              icon: const Icon(Icons.delete),
              label: Text("Excluir"),
              style: TextButton.styleFrom(foregroundColor: AppColors.delete),
              onPressed: _confirmDeleteRecipe,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                textAlign: TextAlign.end,
                'Data: $currentDate',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Por favor preencha o nome.'
                            : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _scoreController,
                decoration: InputDecoration(labelText: 'Nota de 0 a 5'),
                keyboardType: TextInputType.number,
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Por favor preencha a nota.'
                            : null,
              ),
              TextFormField(
                controller: _preparationTimeController,
                decoration: InputDecoration(labelText: 'Tempo de Preparo'),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Por favor preencha o tempo de preparo.'
                            : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: EditFormIngredientListWidget(
                  key: _ingredientListKey,
                  initialIngredients: currentRecipe!.ingredients,
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: EditFormInstructionListWidget(
                  key: _instructionListKey,
                  initialInstructions: currentRecipe!.steps,
                ),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Salvar Receita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
