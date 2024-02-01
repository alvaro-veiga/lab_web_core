import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_core/src/loader/lab_clinicas_loader.dart';


// configuração do core para aplicações externas
// ignore: must_be_immutable
class LabClinicasCoreConfig extends StatelessWidget {

  // no flutter getit, as dependências(bindings) são injetadas através de um singleton que é
  // instanciado na inicialização da aplicação
  LabClinicasCoreConfig({
    super.key,
    this.bindings,
    this.pages,
    this.pagesBuilder,
    this.modules,
    required this.title,
    });
  
  // aplications bindings para injetar dependências
  ApplicationBindings? bindings;

  // lista de rotas para a aplicação
  final List<FlutterGetItPageRouter>? pages;

  // lista de builders para a aplicação
  final List<FlutterGetItPageBuilder>? pagesBuilder;

  // lista de módulos para a aplicação
  final List<FlutterGetItModule>? modules;

  final String title;

  @override
  Widget build(BuildContext context) {
    // utilizando o flutter_getit para injetar dependências
    return FlutterGetIt(
      debugMode: true,

      bindingsBuilder: () => [
        Bind.lazySingleton((i) => 'batata')
      ],

      // adiciona as dependências para a aplicação
      bindings: bindings,

      // adiciona as rotas e os builders para a aplicação
      pages: [...pages ?? [], ...pagesBuilder ?? []],

      // adiciona os módulos para a aplicação
      modules: modules,
      
      builder: (context, routes, flutterGetItNavObserver) {
        // retorna o MaterialApp com as rotas e o observer para checar a navegação do
        return AsyncStateBuilder(

          // adiciona o loader para carregar as dependências
          loader: LabClinicasLoader(),
          
          // adiciona o observer para checar a navegação do usuário sobre as aplicações
          builder: (navigationObserver) {
            // retorna o MaterialApp com as rotas e o observer para checar a navegação do 
            // usuário sobre as aplicações
            return MaterialApp(
              navigatorObservers: [navigationObserver],
              routes: routes,
              title: title,
            );
          }
        );
      },
    );
  }
}