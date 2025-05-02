// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/edit_recipe_screen_arguments_model.dart';
import '../models/ingredient_model.dart';
import '../models/instruction_model.dart';
import '../models/recipe_model.dart';
import '../routes/routes.dart';
import '../services/recipes_service.dart';
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

  List<TextEditingController> ingredientNameControllers = [];
  List<TextEditingController> ingredientQuantityControllers = [];
  List<TextEditingController> stepControllers = [];
  RecipesService service = RecipesService();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scoreController.dispose();
    _preparationTimeController.dispose();
    super.dispose();
  }

  Recipe getDefaultRecipe() {
    return Recipe(
      id: Uuid().v4().toString(),
      title: '',
      description: '',
      score: 0,
      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      preparationTime: '',
      ingredients: [],
      steps: [],
    );
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
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text('Deletar'),
              onPressed: () async {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(Routes.home),
                ); // Fecha o diálogo
                service.deleteRecipe(
                  _idController.text,
                ); // Chama a função de deletar
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm(EditRecipeScreenArgumentsModel args) async {
    if (_formKey.currentState!.validate()) {
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

      var snackBar = SnackBar(
        content: Text("Receita Salva."),
        action: SnackBarAction(label: 'Confirmar', onPressed: () {}),
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

      var sm = ScaffoldMessenger.of(context);
      await service.saveRecipe(updatedRecipe);

      setState(() {
        args.recipe = updatedRecipe;
      });
      sm.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments
            as EditRecipeScreenArgumentsModel;

    final title = args.screenName;

    final recipe = args.recipe ?? getDefaultRecipe();
    _idController.text = recipe.id;
    _titleController.text = recipe.title;
    _descriptionController.text = recipe.description;
    _scoreController.text = recipe.score.toString();
    _preparationTimeController.text = recipe.preparationTime;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          Visibility(
            visible: title == RecipeScreenType.editRecipe,
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
              Text(args.recipe!.title),
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
                  initialIngredients: recipe.ingredients,
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: EditFormInstructionListWidget(
                  key: _instructionListKey,
                  initialInstructions: recipe.steps,
                ),
              ),
              ElevatedButton(
                onPressed: () => _submitForm(args),
                child: const Text('Salvar Receita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
