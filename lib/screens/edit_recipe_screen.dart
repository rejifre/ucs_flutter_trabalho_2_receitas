// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:uuid/uuid.dart';

import 'package:ucs_flutter_trabalho_2_receitas/models/recipe_model.dart';

import '../models/edit_recipe_screen_arguments_model.dart';
import '../models/ingredient_model.dart';
import '../models/instruction_model.dart';
import '../ui/app_colors.dart';
import '../ui/recipe_screen_type.dart';
import 'widgets/edit_form_ingredient_list_widget.dart';
import 'widgets/edit_form_instruction_list_widget.dart';

class EditRecipeScreen extends StatefulWidget {
  final String screenTittle;
  final Recipe? recipe;

  const EditRecipeScreen({super.key, required this.screenTittle, this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<EditFormIngredientListWidgetState> _ingredientListKey =
      GlobalKey<EditFormIngredientListWidgetState>();
  final GlobalKey<EditFormInstructionListWidgetState> _instructionListKey =
      GlobalKey<EditFormInstructionListWidgetState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _preparationTimeController =
      TextEditingController();

  List<TextEditingController> ingredientNameControllers = [];
  List<TextEditingController> ingredientQuantityControllers = [];
  List<TextEditingController> stepControllers = [];

  late Recipe recipe;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      recipe = widget.recipe!;
    }
    recipe = Recipe(
      id: Uuid().v4(),
      title: '',
      description: '',
      score: 0,
      date: DateTime.now(),
      preparationTime: '',
      ingredients: [],
      steps: [],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scoreController.dispose();
    _preparationTimeController.dispose();
    super.dispose();
  }

  void _submitForm() {
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
        ),
      );

      final instructions = List.generate(
        instructionControllers.instructionDescriptionControllers.length,
        (i) => Instruction(
          id: instructionControllers.instructionIds[i],
          stepOrder: i + 1,
          description:
              instructionControllers.instructionDescriptionControllers[i].text,
        ),
      );

      // Agora você pode salvar os ingredientes e instruções com os dados do formulário
      print("Receita enviada com sucesso!");
      print("Ingredientes: $ingredients");
      print("Instruções: $instructions");
    }
  }

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d(recipe);

    _titleController.text = recipe.title;
    _descriptionController.text = recipe.description;
    _scoreController.text = recipe.score.toString();
    _preparationTimeController.text = recipe.preparationTime;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.screenTittle),
        actions: <Widget>[
          Visibility(
            visible: widget.screenTittle == RecipeScreenType.editRecipe,
            child: TextButton.icon(
              icon: const Icon(Icons.delete),
              label: Text("Excluir"),
              style: TextButton.styleFrom(foregroundColor: AppColors.delete),
              onPressed: () {},
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
                  initialIngredients: [],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: EditFormInstructionListWidget(
                  key: _instructionListKey,
                  initialInstructions: [],
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
