// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:polkawallet_ui/components/v3/innerShadow.dart';
import 'package:polkawallet_ui/utils/index.dart';

export 'package:flutter/services.dart' show SmartQuotesType, SmartDashesType;

class TextInputWidget extends StatefulWidget {
  TextInputWidget(
      {this.controller,
      this.focusNode,
      this.onChanged,
      this.autovalidateMode,
      this.decoration,
      this.validator,
      this.obscureText = false,
      this.maxLines = 1,
      this.enabled,
      this.readOnly = false,
      this.inputFormatters,
      this.keyboardType,
      this.style,
      Key? key})
      : super(key: key);
  TextEditingController? controller;
  FocusNode? focusNode;
  void Function(String)? onChanged;
  AutovalidateMode? autovalidateMode;
  InputDecorationV3? decoration = const InputDecorationV3();
  String? Function(String?)? validator;
  bool obscureText;
  int? maxLines;
  bool? enabled;
  bool readOnly;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? keyboardType;
  TextStyle? style;

  @override
  createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  bool hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
        onFocusChange: (hasFocus) async {
          setState(() {
            this.hasFocus = hasFocus;
          });
        },
        child: TextFormField(
          key: const Key("1"),
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          autovalidateMode: widget.autovalidateMode,
          decoration: widget.decoration,
          validator: widget.validator,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          style: widget.style,
          hasFocus: hasFocus,
        ));
  }
}

/// A [FormField] that contains a [TextField].
///
/// This is a convenience widget that wraps a [TextField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// When a [controller] is specified, its [TextEditingController.text]
/// defines the [initialValue]. If this [FormField] is part of a scrolling
/// container that lazily constructs its children, like a [ListView] or a
/// [CustomScrollView], then a [controller] should be specified.
/// The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container.
///
/// If a [controller] is not specified, [initialValue] can be used to give
/// the automatically generated controller an initial value.
///
/// Remember to call [TextEditingController.dispose] of the [TextEditingController]
/// when it is no longer needed. This will ensure we discard any resources used
/// by the object.
///
/// By default, `decoration` will apply the [ThemeData.inputDecorationTheme] for
/// the current context to the [InputDecoration], see
/// [InputDecoration.applyDefaults].
///
/// For a documentation about the various parameters, see [TextField].
///
/// {@tool snippet}
///
/// Creates a [TextFormField] with an [InputDecoration] and validator function.
///
/// ![If the user enters valid text, the TextField appears normally without any warnings to the user](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field.png)
///
/// ![If the user enters invalid text, the error message returned from the validator function is displayed in dark red underneath the input](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field_error.png)
///
/// ```dart
/// TextFormField(
///   decoration: const InputDecoration(
///     icon: Icon(Icons.person),
///     hintText: 'What do people call you?',
///     labelText: 'Name *',
///   ),
///   onSaved: (String? value) {
///     // This optional block of code can be used to run
///     // code when the user saves the form.
///   },
///   validator: (String? value) {
///     return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
///   },
/// )
/// ```
/// {@end-tool}
///
/// {@tool dartpad --template=stateful_widget_material}
/// This example shows how to move the focus to the next field when the user
/// presses the SPACE key.
///
/// ```dart imports
/// import 'package:flutter/services.dart';
/// ```
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return Material(
///     child: Center(
///       child: Shortcuts(
///         shortcuts: const <ShortcutActivator, Intent>{
///           // Pressing space in the field will now move to the next field.
///           SingleActivator(LogicalKeyboardKey.space): NextFocusIntent(),
///         },
///         child: FocusTraversalGroup(
///           child: Form(
///             autovalidateMode: AutovalidateMode.always,
///             onChanged: () {
///               Form.of(primaryFocus!.context!)!.save();
///             },
///             child: Wrap(
///               children: List<Widget>.generate(5, (int index) {
///                 return Padding(
///                   padding: const EdgeInsets.all(8.0),
///                   child: ConstrainedBox(
///                     constraints: BoxConstraints.tight(const Size(200, 50)),
///                     child: TextFormField(
///                       onSaved: (String? value) {
///                         print('Value for field $index saved as "$value"');
///                       },
///                     ),
///                   ),
///                 );
///               }),
///             ),
///           ),
///         ),
///       ),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * <https://material.io/design/components/text-fields.html>
///  * [TextField], which is the underlying text field without the [Form]
///    integration.
///  * [InputDecorator], which shows the labels and other visual elements that
///    surround the actual text editing widget.
///  * Learn how to use a [TextEditingController] in one of our [cookbook recipes](https://flutter.dev/docs/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller).
class TextFormField extends FormField<String> {
  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [new TextField], the constructor.
  TextFormField(
      {Key? key,
      this.controller,
      String? initialValue,
      FocusNode? focusNode,
      InputDecorationV3? decoration = const InputDecorationV3(),
      TextInputType? keyboardType,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextInputAction? textInputAction,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextDirection? textDirection,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      bool autofocus = false,
      bool readOnly = false,
      ToolbarOptions? toolbarOptions,
      bool? showCursor,
      String obscuringCharacter = '•',
      bool obscureText = false,
      bool autocorrect = true,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      @Deprecated(
        'Use autovalidateMode parameter which provide more specific '
        'behaviour related to auto validation. '
        'This feature was deprecated after v1.19.0.',
      )
          bool autovalidate = false,
      @Deprecated(
        'Use maxLengthEnforcement parameter which provides more specific '
        'behavior related to the maxLength limit. '
        'This feature was deprecated after v1.25.0-5.0.pre.',
      )
          MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLines = 1,
      int? minLines,
      bool expands = false,
      // int? maxLength,
      ValueChanged<String>? onChanged,
      GestureTapCallback? onTap,
      VoidCallback? onEditingComplete,
      ValueChanged<String>? onFieldSubmitted,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      List<TextInputFormatter>? inputFormatters,
      bool? enabled,
      // double cursorWidth = 2.0,
      // double? cursorHeight,
      Radius? cursorRadius,
      // Color? cursorColor,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool enableInteractiveSelection = true,
      TextSelectionControls? selectionControls,
      InputCounterWidgetBuilder? buildCounter,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      AutovalidateMode? autovalidateMode,
      ScrollController? scrollController,
      String? restorationId,
      bool enableIMEPersonalizedLearning = true,
      bool hasFocus = false})
      : assert(initialValue == null || controller == null),
        assert(obscuringCharacter.length == 1),
        assert(
          autovalidate == false ||
              autovalidate == true && autovalidateMode == null,
          'autovalidate and autovalidateMode should not be used together.',
        ),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        // assert(maxLength == null ||
        //     maxLength == TextField.noMaxLength ||
        //     maxLength > 0),

        super(
          key: key,
          restorationId: restorationId,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : (autovalidateMode ?? AutovalidateMode.disabled),
          builder: (FormFieldState<String> field) {
            final _TextFormFieldState state = field as _TextFormFieldState;
            final InputDecorationV3 effectiveDecoration = (decoration ??
                    const InputDecorationV3())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            final TextStyle errorStyle = effectiveDecoration.errorStyle ??
                Theme.of(field.context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(field.context).errorColor);
            final labelStyle = effectiveDecoration.labelStyle ??
                Theme.of(field.context).textTheme.bodyText1;
            return UnmanagedRestorationScope(
                bucket: field.bucket,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    decoration?.label != null || decoration?.labelText != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: decoration?.label ??
                                Text(
                                  decoration?.labelText ?? "",
                                  style: labelStyle,
                                ),
                          )
                        : Container(),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        InnerShadowBGCar(
                            isWhite:
                                (enabled ?? decoration!.enabled) ? true : false,
                            child: SizedBox(
                              width: double.infinity,
                              height: 11 + (maxLines ?? 1) * 21,
                            )),
                        Container(
                          height: 11 + 16 + (maxLines ?? 1) * 21,
                          decoration: hasFocus
                              ? BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  border: Border.all(
                                      width: 1.5,
                                      color: Theme.of(field.context)
                                          .toggleableActiveColor))
                              : null,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  restorationId: restorationId,
                                  controller: state._effectiveController,
                                  focusNode: focusNode,
                                  decoration: effectiveDecoration.copyWith(
                                      errorText: null,
                                      label: null,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5.5),
                                      hintStyle: TextStyle(
                                          fontSize:
                                              UI.getTextSize(16, field.context),
                                          fontFamily: UI.getFontFamily(
                                              'TitilliumWeb', field.context),
                                          color: const Color(0x77565554)),
                                      suffix: null,
                                      suffixIcon: null),
                                  keyboardType: keyboardType,
                                  textInputAction: textInputAction,
                                  style: style,
                                  strutStyle: strutStyle,
                                  textAlign: textAlign,
                                  textAlignVertical: textAlignVertical,
                                  textDirection: textDirection,
                                  textCapitalization: textCapitalization,
                                  autofocus: autofocus,
                                  toolbarOptions: toolbarOptions,
                                  readOnly: readOnly,
                                  showCursor: showCursor,
                                  obscuringCharacter: obscuringCharacter,
                                  obscureText: obscureText,
                                  autocorrect: autocorrect,
                                  smartDashesType: smartDashesType ??
                                      (obscureText
                                          ? SmartDashesType.disabled
                                          : SmartDashesType.enabled),
                                  smartQuotesType: smartQuotesType ??
                                      (obscureText
                                          ? SmartQuotesType.disabled
                                          : SmartQuotesType.enabled),
                                  enableSuggestions: enableSuggestions,
                                  maxLengthEnforcement: maxLengthEnforcement,
                                  maxLines: maxLines,
                                  minLines: minLines,
                                  expands: expands,
                                  maxLength: null,
                                  onChanged: onChangedHandler,
                                  onTap: onTap,
                                  onEditingComplete: onEditingComplete,
                                  onSubmitted: onFieldSubmitted,
                                  inputFormatters: inputFormatters,
                                  enabled: enabled ?? decoration!.enabled,
                                  cursorWidth: 2,
                                  cursorHeight: 20,
                                  cursorRadius: cursorRadius,
                                  cursorColor: Theme.of(field.context)
                                      .toggleableActiveColor,
                                  scrollPadding: scrollPadding,
                                  scrollPhysics: scrollPhysics,
                                  keyboardAppearance: keyboardAppearance,
                                  enableInteractiveSelection:
                                      enableInteractiveSelection,
                                  selectionControls: selectionControls,
                                  buildCounter: buildCounter,
                                  autofillHints: autofillHints,
                                  scrollController: scrollController,
                                  enableIMEPersonalizedLearning:
                                      enableIMEPersonalizedLearning,
                                )),
                                decoration!.suffix != null
                                    ? decoration.suffix!
                                    : decoration.suffixIcon != null
                                        ? decoration.suffixIcon!
                                        : Container()
                              ],
                            )),
                      ],
                    ),
                    field.errorText != null && field.errorText!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              field.errorText!,
                              style: errorStyle,
                            ),
                          )
                        : Container()
                  ],
                ));
          },
        );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  @override
  FormFieldState<String> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!.value;

  @override
  TextFormField get widget => super.widget as TextFormField;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    // Make sure to update the internal [FormFieldState] value to sync up with
    // text editing controller value.
    setValue(_effectiveController.text);
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _createLocalController(widget.initialValue != null
          ? TextEditingValue(text: widget.initialValue!)
          : null);
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(TextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  @override
  void reset() {
    // setState will be called in the superclass, so even though state is being
    // manipulated, no setState call is needed here.
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}

class InputDecorationV3 extends InputDecoration {
  /// Creates a bundle of the border, labels, icons, and styles used to
  /// decorate a Material Design text field.
  ///
  /// Unless specified by [ThemeData.inputDecorationTheme], [InputDecorator]
  /// defaults [isDense] to false and [filled] to false. The default border is
  /// an instance of [UnderlineInputBorder]. If [border] is [InputBorder.none]
  /// then no border is drawn.
  ///
  /// The [enabled] argument must not be null.
  ///
  /// Only one of [prefix] and [prefixText] can be specified.
  ///
  /// Similarly, only one of [suffix] and [suffixText] can be specified.
  const InputDecorationV3({
    this.icon,
    this.label,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    this.hintText,
    this.hintStyle,
    this.hintTextDirection,
    this.hintMaxLines,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
    this.floatingLabelBehavior,
    this.isCollapsed = false,
    this.isDense,
    this.contentPadding,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.prefix,
    this.prefixText,
    this.prefixStyle,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconConstraints,
    this.counter,
    this.counterText,
    this.counterStyle,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.border = InputBorder.none,
    this.enabled = true,
    this.semanticCounterText,
    this.alignLabelWithHint,
    this.constraints,
    this.floatingLabelAlignment = FloatingLabelAlignment.start,
  })  : assert(!(label != null && labelText != null),
            'Declaring both label and labelText is not supported.'),
        assert(!(prefix != null && prefixText != null),
            'Declaring both prefix and prefixText is not supported.'),
        assert(!(suffix != null && suffixText != null),
            'Declaring both suffix and suffixText is not supported.');

  /// Defines an [InputDecorator] that is the same size as the input field.
  ///
  /// This type of input decoration does not include a border by default.
  ///
  /// Sets the [isCollapsed] property to true.
  const InputDecorationV3.collapsed(
    this.floatingLabelAlignment, {
    required this.hintText,
    this.floatingLabelBehavior,
    this.hintStyle,
    this.hintTextDirection,
    this.filled = false,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.border = InputBorder.none,
    this.enabled = true,
  })  : icon = null,
        label = null,
        labelText = null,
        labelStyle = null,
        floatingLabelStyle = null,
        helperText = null,
        helperStyle = null,
        helperMaxLines = null,
        hintMaxLines = null,
        errorText = null,
        errorStyle = null,
        errorMaxLines = null,
        isDense = false,
        contentPadding = EdgeInsets.zero,
        isCollapsed = true,
        prefixIcon = null,
        prefix = null,
        prefixText = null,
        prefixStyle = null,
        prefixIconConstraints = null,
        suffix = null,
        suffixIcon = null,
        suffixText = null,
        suffixStyle = null,
        suffixIconConstraints = null,
        counter = null,
        counterText = null,
        counterStyle = null,
        errorBorder = null,
        focusedBorder = null,
        focusedErrorBorder = null,
        disabledBorder = null,
        enabledBorder = null,
        semanticCounterText = null,
        alignLabelWithHint = false,
        constraints = null;

  /// An icon to show before the input field and outside of the decoration's
  /// container.
  ///
  /// The size and color of the icon is configured automatically using an
  /// [IconTheme] and therefore does not need to be explicitly given in the
  /// icon widget.
  ///
  /// The trailing edge of the icon is padded by 16dps.
  ///
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [icon] and above the widgets that contain [helperText],
  /// [errorText], and [counterText].
  ///
  /// See [Icon], [ImageIcon].
  final Widget? icon;

  /// Optional widget that describes the input field.
  ///
  /// {@template flutter.material.inputDecoration.label}
  /// When the input field is empty and unfocused, the label is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the input field). When the input field receives
  /// focus (or if the field is non-empty), the label moves above (i.e.,
  /// vertically adjacent to) the input field.
  /// {@endtemplate}
  ///
  /// This can be used, for example, to add multiple [TextStyle]'s to a label that would
  /// otherwise be specified using [labelText], which only takes one [TextStyle].
  ///
  /// {@tool dartpad --template=stateless_widget_scaffold}
  ///
  /// This example shows a `TextField` with a [Text.rich] widget as the [label].
  /// The widget contains multiple [Text] widgets with different [TextStyle]'s.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return const Center(
  ///     child: TextField(
  ///       decoration: InputDecoration(
  ///         label: Text.rich(
  ///           TextSpan(
  ///             children: <InlineSpan>[
  ///               WidgetSpan(
  ///                 child: Text(
  ///                   'Username',
  ///                 ),
  ///               ),
  ///               WidgetSpan(
  ///                 child: Text(
  ///                   '*',
  ///                   style: TextStyle(color: Colors.red),
  ///                 ),
  ///               ),
  ///             ],
  ///           ),
  ///         ),
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// Only one of [label] and [labelText] can be specified.
  final Widget? label;

  /// Optional text that describes the input field.
  ///
  /// {@macro flutter.material.inputDecoration.label}
  ///
  /// If a more elaborate label is required, consider using [label] instead.
  /// Only one of [label] and [labelText] can be specified.
  final String? labelText;

  /// The style to use for the [labelText] when the label is on top of the
  /// input field.
  ///
  /// When the [labelText] is above (i.e., vertically adjacent to) the input
  /// field, the text uses the [floatingLabelStyle] instead.
  ///
  /// If null, defaults to a value derived from the base [TextStyle] for the
  /// input field and the current [Theme].
  final TextStyle? labelStyle;

  /// The style to use for the [labelText] when the label is above (i.e.,
  /// vertically adjacent to) the input field.
  ///
  /// If null, defaults to [labelStyle].
  final TextStyle? floatingLabelStyle;

  /// Text that provides context about the [InputDecorator.child]'s value, such
  /// as how the value will be used.
  ///
  /// If non-null, the text is displayed below the [InputDecorator.child], in
  /// the same location as [errorText]. If a non-null [errorText] value is
  /// specified then the helper text is not shown.
  final String? helperText;

  /// The style to use for the [helperText].
  final TextStyle? helperStyle;

  /// The maximum number of lines the [helperText] can occupy.
  ///
  /// Defaults to null, which means that the [helperText] will be limited
  /// to a single line with [TextOverflow.ellipsis].
  ///
  /// This value is passed along to the [Text.maxLines] attribute
  /// of the [Text] widget used to display the helper.
  ///
  /// See also:
  ///
  ///  * [errorMaxLines], the equivalent but for the [errorText].
  final int? helperMaxLines;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed on top of the [InputDecorator.child] (i.e., at the same location
  /// on the screen where text may be entered in the [InputDecorator.child])
  /// when the input [isEmpty] and either (a) [labelText] is null or (b) the
  /// input has the focus.
  final String? hintText;

  /// The style to use for the [hintText].
  ///
  /// Also used for the [labelText] when the [labelText] is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the [InputDecorator.child]).
  ///
  /// If null, defaults to a value derived from the base [TextStyle] for the
  /// input field and the current [Theme].
  final TextStyle? hintStyle;

  /// The direction to use for the [hintText].
  ///
  /// If null, defaults to a value derived from [Directionality] for the
  /// input field and the current context.
  final TextDirection? hintTextDirection;

  /// The maximum number of lines the [hintText] can occupy.
  ///
  /// Defaults to the value of [TextField.maxLines] attribute.
  ///
  /// This value is passed along to the [Text.maxLines] attribute
  /// of the [Text] widget used to display the hint text. [TextOverflow.ellipsis] is
  /// used to handle the overflow when it is limited to single line.
  final int? hintMaxLines;

  /// Text that appears below the [InputDecorator.child] and the border.
  ///
  /// If non-null, the border's color animates to red and the [helperText] is
  /// not shown.
  ///
  /// In a [TextFormField], this is overridden by the value returned from
  /// [TextFormField.validator], if that is not null.
  final String? errorText;

  /// The style to use for the [errorText].
  ///
  /// If null, defaults of a value derived from the base [TextStyle] for the
  /// input field and the current [Theme].
  final TextStyle? errorStyle;

  /// The maximum number of lines the [errorText] can occupy.
  ///
  /// Defaults to null, which means that the [errorText] will be limited
  /// to a single line with [TextOverflow.ellipsis].
  ///
  /// This value is passed along to the [Text.maxLines] attribute
  /// of the [Text] widget used to display the error.
  ///
  /// See also:
  ///
  ///  * [helperMaxLines], the equivalent but for the [helperText].
  final int? errorMaxLines;

  /// {@template flutter.material.inputDecoration.floatingLabelBehavior}
  /// Defines how the floating label should be displayed.
  ///
  /// When [FloatingLabelBehavior.auto] the label will float to the top only when
  /// the field is focused or has some text content, otherwise it will appear
  /// in the field in place of the content.
  ///
  /// When [FloatingLabelBehavior.always] the label will always float at the top
  /// of the field above the content.
  ///
  /// When [FloatingLabelBehavior.never] the label will always appear in an empty
  /// field in place of the content.
  /// {@endtemplate}
  ///
  /// If null, [InputDecorationTheme.floatingLabelBehavior] will be used.
  final FloatingLabelBehavior? floatingLabelBehavior;

  /// Whether the [InputDecorator.child] is part of a dense form (i.e., uses less vertical
  /// space).
  ///
  /// Defaults to false.
  final bool? isDense;

  /// The padding for the input decoration's container.
  ///
  /// The decoration's container is the area which is filled if [filled] is true
  /// and bordered per the [border]. It's the area adjacent to [icon] and above
  /// the widgets that contain [helperText], [errorText], and [counterText].
  ///
  /// By default the `contentPadding` reflects [isDense] and the type of the
  /// [border].
  ///
  /// If [isCollapsed] is true then `contentPadding` is [EdgeInsets.zero].
  ///
  /// If `isOutline` property of [border] is false and if [filled] is true then
  /// `contentPadding` is `EdgeInsets.fromLTRB(12, 8, 12, 8)` when [isDense]
  /// is true and `EdgeInsets.fromLTRB(12, 12, 12, 12)` when [isDense] is false.
  /// If `isOutline` property of [border] is false and if [filled] is false then
  /// `contentPadding` is `EdgeInsets.fromLTRB(0, 8, 0, 8)` when [isDense] is
  /// true and `EdgeInsets.fromLTRB(0, 12, 0, 12)` when [isDense] is false.
  ///
  /// If `isOutline` property of [border] is true then `contentPadding` is
  /// `EdgeInsets.fromLTRB(12, 20, 12, 12)` when [isDense] is true
  /// and `EdgeInsets.fromLTRB(12, 24, 12, 16)` when [isDense] is false.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether the decoration is the same size as the input field.
  ///
  /// A collapsed decoration cannot have [labelText], [errorText], an [icon].
  ///
  /// To create a collapsed input decoration, use [InputDecoration.collapsed].
  final bool isCollapsed;

  /// An icon that appears before the [prefix] or [prefixText] and before
  /// the editable part of the text field, within the decoration's container.
  ///
  /// The size and color of the prefix icon is configured automatically using an
  /// [IconTheme] and therefore does not need to be explicitly given in the
  /// icon widget.
  ///
  /// The prefix icon is constrained with a minimum size of 48px by 48px, but
  /// can be expanded beyond that. Anything larger than 24px will require
  /// additional padding to ensure it matches the material spec of 12px padding
  /// between the left edge of the input and leading edge of the prefix icon.
  /// The following snippet shows how to pad the leading edge of the prefix
  /// icon:
  ///
  /// ```dart
  /// prefixIcon: Padding(
  ///   padding: const EdgeInsetsDirectional.only(start: 12.0),
  ///   child: myIcon, // myIcon is a 48px-wide widget.
  /// )
  /// ```
  ///
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [icon] and above the widgets that contain [helperText],
  /// [errorText], and [counterText].
  ///
  /// See also:
  ///
  ///  * [Icon] and [ImageIcon], which are typically used to show icons.
  ///  * [prefix] and [prefixText], which are other ways to show content
  ///    before the text field (but after the icon).
  ///  * [suffixIcon], which is the same but on the trailing edge.
  final Widget? prefixIcon;

  /// The constraints for the prefix icon.
  ///
  /// This can be used to modify the [BoxConstraints] surrounding [prefixIcon].
  ///
  /// This property is particularly useful for getting the decoration's height
  /// less than 48px. This can be achieved by setting [isDense] to true and
  /// setting the constraints' minimum height and width to a value lower than
  /// 48px.
  ///
  /// {@tool dartpad --template=stateless_widget_scaffold}
  ///
  /// This example shows the differences between two `TextField` widgets when
  /// [prefixIconConstraints] is set to the default value and when one is not.
  ///
  /// Note that [isDense] must be set to true to be able to
  /// set the constraints smaller than 48px.
  ///
  /// If null, [BoxConstraints] with a minimum width and height of 48px is
  /// used.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Padding(
  ///     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  ///     child: Column(
  ///       mainAxisAlignment: MainAxisAlignment.center,
  ///       children: const <Widget>[
  ///         TextField(
  ///           decoration: InputDecoration(
  ///             hintText: 'Normal Icon Constraints',
  ///             prefixIcon: Icon(Icons.search),
  ///           ),
  ///         ),
  ///         SizedBox(height: 10),
  ///         TextField(
  ///           decoration: InputDecoration(
  ///             isDense: true,
  ///             hintText:'Smaller Icon Constraints',
  ///             prefixIcon: Icon(Icons.search),
  ///             prefixIconConstraints: BoxConstraints(
  ///               minHeight: 32,
  ///               minWidth: 32,
  ///             ),
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final BoxConstraints? prefixIconConstraints;

  /// Optional widget to place on the line before the input.
  ///
  /// This can be used, for example, to add some padding to text that would
  /// otherwise be specified using [prefixText], or to add a custom widget in
  /// front of the input. The widget's baseline is lined up with the input
  /// baseline.
  ///
  /// Only one of [prefix] and [prefixText] can be specified.
  ///
  /// The [prefix] appears after the [prefixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [suffix], the equivalent but on the trailing edge.
  final Widget? prefix;

  /// Optional text prefix to place on the line before the input.
  ///
  /// Uses the [prefixStyle]. Uses [hintStyle] if [prefixStyle] isn't specified.
  /// The prefix text is not returned as part of the user's input.
  ///
  /// If a more elaborate prefix is required, consider using [prefix] instead.
  /// Only one of [prefix] and [prefixText] can be specified.
  ///
  /// The [prefixText] appears after the [prefixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [suffixText], the equivalent but on the trailing edge.
  final String? prefixText;

  /// The style to use for the [prefixText].
  ///
  /// If null, defaults to the [hintStyle].
  ///
  /// See also:
  ///
  ///  * [suffixStyle], the equivalent but on the trailing edge.
  final TextStyle? prefixStyle;

  /// An icon that appears after the editable part of the text field and
  /// after the [suffix] or [suffixText], within the decoration's container.
  ///
  /// The size and color of the suffix icon is configured automatically using an
  /// [IconTheme] and therefore does not need to be explicitly given in the
  /// icon widget.
  ///
  /// The suffix icon is constrained with a minimum size of 48px by 48px, but
  /// can be expanded beyond that. Anything larger than 24px will require
  /// additional padding to ensure it matches the material spec of 12px padding
  /// between the right edge of the input and trailing edge of the prefix icon.
  /// The following snippet shows how to pad the trailing edge of the suffix
  /// icon:
  ///
  /// ```dart
  /// suffixIcon: Padding(
  ///   padding: const EdgeInsetsDirectional.only(end: 12.0),
  ///   child: myIcon, // myIcon is a 48px-wide widget.
  /// )
  /// ```
  ///
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [icon] and above the widgets that contain [helperText],
  /// [errorText], and [counterText].
  ///
  /// See also:
  ///
  ///  * [Icon] and [ImageIcon], which are typically used to show icons.
  ///  * [suffix] and [suffixText], which are other ways to show content
  ///    after the text field (but before the icon).
  ///  * [prefixIcon], which is the same but on the leading edge.
  final Widget? suffixIcon;

  /// Optional widget to place on the line after the input.
  ///
  /// This can be used, for example, to add some padding to the text that would
  /// otherwise be specified using [suffixText], or to add a custom widget after
  /// the input. The widget's baseline is lined up with the input baseline.
  ///
  /// Only one of [suffix] and [suffixText] can be specified.
  ///
  /// The [suffix] appears before the [suffixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [prefix], the equivalent but on the leading edge.
  final Widget? suffix;

  /// Optional text suffix to place on the line after the input.
  ///
  /// Uses the [suffixStyle]. Uses [hintStyle] if [suffixStyle] isn't specified.
  /// The suffix text is not returned as part of the user's input.
  ///
  /// If a more elaborate suffix is required, consider using [suffix] instead.
  /// Only one of [suffix] and [suffixText] can be specified.
  ///
  /// The [suffixText] appears before the [suffixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [prefixText], the equivalent but on the leading edge.
  final String? suffixText;

  /// The style to use for the [suffixText].
  ///
  /// If null, defaults to the [hintStyle].
  ///
  /// See also:
  ///
  ///  * [prefixStyle], the equivalent but on the leading edge.
  final TextStyle? suffixStyle;

  /// The constraints for the suffix icon.
  ///
  /// This can be used to modify the [BoxConstraints] surrounding [suffixIcon].
  ///
  /// This property is particularly useful for getting the decoration's height
  /// less than 48px. This can be achieved by setting [isDense] to true and
  /// setting the constraints' minimum height and width to a value lower than
  /// 48px.
  ///
  /// If null, a [BoxConstraints] with a minimum width and height of 48px is
  /// used.
  ///
  /// {@tool dartpad --template=stateless_widget_scaffold}
  /// This example shows the differences between two `TextField` widgets when
  /// [suffixIconConstraints] is set to the default value and when one is not.
  ///
  /// Note that [isDense] must be set to true to be able to
  /// set the constraints smaller than 48px.
  ///
  /// If null, [BoxConstraints] with a minimum width and height of 48px is
  /// used.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Padding(
  ///     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  ///     child: Column(
  ///       mainAxisAlignment: MainAxisAlignment.center,
  ///       children: const <Widget>[
  ///         TextField(
  ///           decoration: InputDecoration(
  ///             hintText: 'Normal Icon Constraints',
  ///             suffixIcon: Icon(Icons.search),
  ///           ),
  ///         ),
  ///         SizedBox(height: 10),
  ///         TextField(
  ///           decoration: InputDecoration(
  ///             isDense: true,
  ///             hintText:'Smaller Icon Constraints',
  ///             suffixIcon: Icon(Icons.search),
  ///             suffixIconConstraints: BoxConstraints(
  ///               minHeight: 32,
  ///               minWidth: 32,
  ///             ),
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final BoxConstraints? suffixIconConstraints;

  /// Optional text to place below the line as a character count.
  ///
  /// Rendered using [counterStyle]. Uses [helperStyle] if [counterStyle] is
  /// null.
  ///
  /// The semantic label can be replaced by providing a [semanticCounterText].
  ///
  /// If null or an empty string and [counter] isn't specified, then nothing
  /// will appear in the counter's location.
  final String? counterText;

  /// Optional custom counter widget to go in the place otherwise occupied by
  /// [counterText].  If this property is non null, then [counterText] is
  /// ignored.
  final Widget? counter;

  /// The style to use for the [counterText].
  ///
  /// If null, defaults to the [helperStyle].
  final TextStyle? counterStyle;

  /// If true the decoration's container is filled with [fillColor].
  ///
  /// When [InputDecorator.isHovering] is true, the [hoverColor] is also blended
  /// into the final fill color.
  ///
  /// Typically this field set to true if [border] is an
  /// [UnderlineInputBorder].
  ///
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [icon] and above the widgets that contain [helperText],
  /// [errorText], and [counterText].
  ///
  /// This property is false by default.
  final bool? filled;

  /// The base fill color of the decoration's container color.
  ///
  /// When [InputDecorator.isHovering] is true, the
  /// [hoverColor] is also blended into the final fill color.
  ///
  /// By default the fillColor is based on the current [Theme].
  ///
  /// The decoration's container is the area which is filled if [filled] is true
  /// and bordered per the [border]. It's the area adjacent to [icon] and above
  /// the widgets that contain [helperText], [errorText], and [counterText].
  final Color? fillColor;

  /// By default the [focusColor] is based on the current [Theme].
  ///
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [icon] and above the widgets that contain [helperText],
  /// [errorText], and [counterText].
  final Color? focusColor;

  /// The color of the focus highlight for the decoration shown if the container
  /// is being hovered over by a mouse.
  ///
  /// If [filled] is true, the color is blended with [fillColor] and fills the
  /// decoration's container.
  ///
  /// If [filled] is false, and [InputDecorator.isFocused] is false, the color
  /// is blended over the [enabledBorder]'s color.
  ///
  /// By default the [hoverColor] is based on the current [Theme].
  ///
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [icon] and above the widgets that contain [helperText],
  /// [errorText], and [counterText].
  final Color? hoverColor;

  /// The border to display when the [InputDecorator] does not have the focus and
  /// is showing an error.
  ///
  /// See also:
  ///
  ///  * [InputDecorator.isFocused], which is true if the [InputDecorator]'s child
  ///    has the focus.
  ///  * [InputDecoration.errorText], the error shown by the [InputDecorator], if non-null.
  ///  * [border], for a description of where the [InputDecorator] border appears.
  ///  * [UnderlineInputBorder], an [InputDecorator] border which draws a horizontal
  ///    line at the bottom of the input decorator's container.
  ///  * [OutlineInputBorder], an [InputDecorator] border which draws a
  ///    rounded rectangle around the input decorator's container.
  ///  * [InputBorder.none], which doesn't draw a border.
  ///  * [focusedBorder], displayed when [InputDecorator.isFocused] is true
  ///    and [InputDecoration.errorText] is null.
  ///  * [focusedErrorBorder], displayed when [InputDecorator.isFocused] is true
  ///    and [InputDecoration.errorText] is non-null.
  ///  * [disabledBorder], displayed when [InputDecoration.enabled] is false
  ///    and [InputDecoration.errorText] is null.
  ///  * [enabledBorder], displayed when [InputDecoration.enabled] is true
  ///    and [InputDecoration.errorText] is null.
  final InputBorder? errorBorder;

  /// The border to display when the [InputDecorator] has the focus and is not
  /// showing an error.
  ///
  /// See also:
  ///
  ///  * [InputDecorator.isFocused], which is true if the [InputDecorator]'s child
  ///    has the focus.
  ///  * [InputDecoration.errorText], the error shown by the [InputDecorator], if non-null.
  ///  * [border], for a description of where the [InputDecorator] border appears.
  ///  * [UnderlineInputBorder], an [InputDecorator] border which draws a horizontal
  ///    line at the bottom of the input decorator's container.
  ///  * [OutlineInputBorder], an [InputDecorator] border which draws a
  ///    rounded rectangle around the input decorator's container.
  ///  * [InputBorder.none], which doesn't draw a border.
  ///  * [errorBorder], displayed when [InputDecorator.isFocused] is false
  ///    and [InputDecoration.errorText] is non-null.
  ///  * [focusedErrorBorder], displayed when [InputDecorator.isFocused] is true
  ///    and [InputDecoration.errorText] is non-null.
  ///  * [disabledBorder], displayed when [InputDecoration.enabled] is false
  ///    and [InputDecoration.errorText] is null.
  ///  * [enabledBorder], displayed when [InputDecoration.enabled] is true
  ///    and [InputDecoration.errorText] is null.
  final InputBorder? focusedBorder;

  /// The border to display when the [InputDecorator] has the focus and is
  /// showing an error.
  ///
  /// See also:
  ///
  ///  * [InputDecorator.isFocused], which is true if the [InputDecorator]'s child
  ///    has the focus.
  ///  * [InputDecoration.errorText], the error shown by the [InputDecorator], if non-null.
  ///  * [border], for a description of where the [InputDecorator] border appears.
  ///  * [UnderlineInputBorder], an [InputDecorator] border which draws a horizontal
  ///    line at the bottom of the input decorator's container.
  ///  * [OutlineInputBorder], an [InputDecorator] border which draws a
  ///    rounded rectangle around the input decorator's container.
  ///  * [InputBorder.none], which doesn't draw a border.
  ///  * [errorBorder], displayed when [InputDecorator.isFocused] is false
  ///    and [InputDecoration.errorText] is non-null.
  ///  * [focusedBorder], displayed when [InputDecorator.isFocused] is true
  ///    and [InputDecoration.errorText] is null.
  ///  * [disabledBorder], displayed when [InputDecoration.enabled] is false
  ///    and [InputDecoration.errorText] is null.
  ///  * [enabledBorder], displayed when [InputDecoration.enabled] is true
  ///    and [InputDecoration.errorText] is null.
  final InputBorder? focusedErrorBorder;

  /// The border to display when the [InputDecorator] is disabled and is not
  /// showing an error.
  ///
  /// See also:
  ///
  ///  * [InputDecoration.enabled], which is false if the [InputDecorator] is disabled.
  ///  * [InputDecoration.errorText], the error shown by the [InputDecorator], if non-null.
  ///  * [border], for a description of where the [InputDecorator] border appears.
  ///  * [UnderlineInputBorder], an [InputDecorator] border which draws a horizontal
  ///    line at the bottom of the input decorator's container.
  ///  * [OutlineInputBorder], an [InputDecorator] border which draws a
  ///    rounded rectangle around the input decorator's container.
  ///  * [InputBorder.none], which doesn't draw a border.
  ///  * [errorBorder], displayed when [InputDecorator.isFocused] is false
  ///    and [InputDecoration.errorText] is non-null.
  ///  * [focusedBorder], displayed when [InputDecorator.isFocused] is true
  ///    and [InputDecoration.errorText] is null.
  ///  * [focusedErrorBorder], displayed when [InputDecorator.isFocused] is true
  ///    and [InputDecoration.errorText] is non-null.
  ///  * [enabledBorder], displayed when [InputDecoration.enabled] is true
  ///    and [InputDecoration.errorText] is null.
  final InputBorder? disabledBorder;

  /// The border to display when the [InputDecorator] is enabled and is not
  /// showing an error.
  ///
  /// See also:
  ///
  ///  * [InputDecoration.enabled], which is false if the [InputDecorator] is disabled.
  ///  * [InputDecoration.errorText], the error shown by the [InputDecorator], if non-null.
  ///  * [border], for a description of where the [InputDecorator] border appears.
  ///  * [UnderlineInputBorder], an [InputDecorator] border which draws a horizontal
  ///    line at the bottom of the input decorator's container.
  ///  * [OutlineInputBorder], an [InputDecorator] border which draws a
  ///    rounded rectangle around the input decorator's container.
  ///  * [InputBorder.none], which doesn't draw a border.
  ///  * [errorBorder], displayed when [InputDecorator.isFocused] is false
  ///    and [InputDecoration.errorText] is non-null.
  ///  * [focusedBorder], displayed when [InputDecorator.isFocused] is true
  ///    and [InputDecoration.errorText] is null.
  ///  * [focusedErrorBorder], displayed when [InputDecorator.isFocused] is true
  ///    and [InputDecoration.errorText] is non-null.
  ///  * [disabledBorder], displayed when [InputDecoration.enabled] is false
  ///    and [InputDecoration.errorText] is null.
  final InputBorder? enabledBorder;

  /// The shape of the border to draw around the decoration's container.
  ///
  /// This border's [InputBorder.borderSide], i.e. the border's color and width,
  /// will be overridden to reflect the input decorator's state. Only the
  /// border's shape is used. If custom  [BorderSide] values are desired for
  /// a given state, all four borders – [errorBorder], [focusedBorder],
  /// [enabledBorder], [disabledBorder] – must be set.
  ///
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [InputDecoration.icon] and above the widgets that contain
  /// [InputDecoration.helperText], [InputDecoration.errorText], and
  /// [InputDecoration.counterText].
  ///
  /// The border's bounds, i.e. the value of `border.getOuterPath()`, define
  /// the area to be filled.
  ///
  /// This property is only used when the appropriate one of [errorBorder],
  /// [focusedBorder], [focusedErrorBorder], [disabledBorder], or [enabledBorder]
  /// is not specified. This border's [InputBorder.borderSide] property is
  /// configured by the InputDecorator, depending on the values of
  /// [InputDecoration.errorText], [InputDecoration.enabled],
  /// [InputDecorator.isFocused] and the current [Theme].
  ///
  /// Typically one of [UnderlineInputBorder] or [OutlineInputBorder].
  /// If null, InputDecorator's default is `const UnderlineInputBorder()`.
  ///
  /// See also:
  ///
  ///  * [InputBorder.none], which doesn't draw a border.
  ///  * [UnderlineInputBorder], which draws a horizontal line at the
  ///    bottom of the input decorator's container.
  ///  * [OutlineInputBorder], an [InputDecorator] border which draws a
  ///    rounded rectangle around the input decorator's container.
  final InputBorder? border;

  /// If false [helperText],[errorText], and [counterText] are not displayed,
  /// and the opacity of the remaining visual elements is reduced.
  ///
  /// This property is true by default.
  final bool enabled;

  /// A semantic label for the [counterText].
  ///
  /// Defaults to null.
  ///
  /// If provided, this replaces the semantic label of the [counterText].
  final String? semanticCounterText;

  /// Typically set to true when the [InputDecorator] contains a multiline
  /// [TextField] ([TextField.maxLines] is null or > 1) to override the default
  /// behavior of aligning the label with the center of the [TextField].
  ///
  /// Defaults to false.
  final bool? alignLabelWithHint;

  /// Defines minimum and maximum sizes for the [InputDecorator].
  ///
  /// Typically the decorator will fill the horizontal space it is given. For
  /// larger screens, it may be useful to have the maximum width clamped to
  /// a given value so it doesn't fill the whole screen. This property
  /// allows you to control how big the decorator will be in its available
  /// space.
  ///
  /// If null, then the ambient [ThemeData.inputDecorationTheme]'s
  /// [InputDecorationTheme.constraints] will be used. If that
  /// is null then the decorator will fill the available width with
  /// a default height based on text size.
  final BoxConstraints? constraints;

  final FloatingLabelAlignment? floatingLabelAlignment;

  /// Creates a copy of this input decoration with the given fields replaced
  /// by the new values.
  InputDecorationV3 copyWith({
    Widget? icon,
    Color? iconColor,
    Widget? label,
    String? labelText,
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    String? helperText,
    TextStyle? helperStyle,
    int? helperMaxLines,
    String? hintText,
    TextStyle? hintStyle,
    TextDirection? hintTextDirection,
    int? hintMaxLines,
    String? errorText,
    TextStyle? errorStyle,
    int? errorMaxLines,
    FloatingLabelBehavior? floatingLabelBehavior,
    FloatingLabelAlignment? floatingLabelAlignment,
    bool? isCollapsed,
    bool? isDense,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon,
    Widget? prefix,
    String? prefixText,
    BoxConstraints? prefixIconConstraints,
    TextStyle? prefixStyle,
    Color? prefixIconColor,
    Widget? suffixIcon,
    Widget? suffix,
    String? suffixText,
    TextStyle? suffixStyle,
    Color? suffixIconColor,
    BoxConstraints? suffixIconConstraints,
    Widget? counter,
    String? counterText,
    TextStyle? counterStyle,
    bool? filled,
    Color? fillColor,
    Color? focusColor,
    Color? hoverColor,
    InputBorder? errorBorder,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? border,
    bool? enabled,
    String? semanticCounterText,
    bool? alignLabelWithHint,
    BoxConstraints? constraints,
  }) {
    return InputDecorationV3(
      icon: icon ?? this.icon,
      label: label,
      labelText: labelText,
      labelStyle: labelStyle ?? this.labelStyle,
      floatingLabelStyle: floatingLabelStyle ?? this.floatingLabelStyle,
      helperText: helperText ?? this.helperText,
      helperStyle: helperStyle ?? this.helperStyle,
      helperMaxLines: helperMaxLines ?? this.helperMaxLines,
      hintText: hintText ?? this.hintText,
      hintStyle: hintStyle ?? this.hintStyle,
      hintTextDirection: hintTextDirection ?? this.hintTextDirection,
      hintMaxLines: hintMaxLines ?? this.hintMaxLines,
      errorText: errorText ?? this.errorText,
      errorStyle: errorStyle ?? this.errorStyle,
      errorMaxLines: errorMaxLines ?? this.errorMaxLines,
      floatingLabelBehavior:
          floatingLabelBehavior ?? this.floatingLabelBehavior,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      isDense: isDense ?? this.isDense,
      contentPadding: contentPadding ?? this.contentPadding,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      prefix: prefix ?? this.prefix,
      prefixText: prefixText ?? this.prefixText,
      prefixStyle: prefixStyle ?? this.prefixStyle,
      prefixIconConstraints:
          prefixIconConstraints ?? this.prefixIconConstraints,
      suffixIcon: suffixIcon,
      suffix: suffix,
      suffixText: suffixText ?? this.suffixText,
      suffixStyle: suffixStyle ?? this.suffixStyle,
      suffixIconConstraints:
          suffixIconConstraints ?? this.suffixIconConstraints,
      counter: counter ?? this.counter,
      counterText: counterText ?? this.counterText,
      counterStyle: counterStyle ?? this.counterStyle,
      filled: filled ?? this.filled,
      fillColor: fillColor ?? this.fillColor,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      errorBorder: errorBorder ?? this.errorBorder,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      focusedErrorBorder: focusedErrorBorder ?? this.focusedErrorBorder,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      enabledBorder: enabledBorder ?? this.enabledBorder,
      border: border ?? this.border,
      enabled: enabled ?? this.enabled,
      semanticCounterText: semanticCounterText ?? this.semanticCounterText,
      alignLabelWithHint: alignLabelWithHint ?? this.alignLabelWithHint,
      constraints: constraints ?? this.constraints,
    );
  }

  /// Used by widgets like [TextField] and [InputDecorator] to create a new
  /// [InputDecoration] with default values taken from the [theme].
  ///
  /// Only null valued properties from this [InputDecoration] are replaced
  /// by the corresponding values from [theme].
  InputDecorationV3 applyDefaults(InputDecorationTheme theme) {
    return copyWith(
      labelStyle: labelStyle ?? theme.labelStyle,
      floatingLabelStyle: floatingLabelStyle ?? theme.floatingLabelStyle,
      helperStyle: helperStyle ?? theme.helperStyle,
      helperMaxLines: helperMaxLines ?? theme.helperMaxLines,
      hintStyle: hintStyle ?? theme.hintStyle,
      errorStyle: errorStyle ?? theme.errorStyle,
      errorMaxLines: errorMaxLines ?? theme.errorMaxLines,
      floatingLabelBehavior:
          floatingLabelBehavior ?? theme.floatingLabelBehavior,
      isCollapsed: isCollapsed,
      isDense: isDense ?? theme.isDense,
      contentPadding: contentPadding ?? theme.contentPadding,
      prefixStyle: prefixStyle ?? theme.prefixStyle,
      suffixStyle: suffixStyle ?? theme.suffixStyle,
      counterStyle: counterStyle ?? theme.counterStyle,
      filled: filled ?? theme.filled,
      fillColor: fillColor ?? theme.fillColor,
      focusColor: focusColor ?? theme.focusColor,
      hoverColor: hoverColor ?? theme.hoverColor,
      errorBorder: errorBorder ?? theme.errorBorder,
      focusedBorder: focusedBorder ?? theme.focusedBorder,
      focusedErrorBorder: focusedErrorBorder ?? theme.focusedErrorBorder,
      disabledBorder: disabledBorder ?? theme.disabledBorder,
      enabledBorder: enabledBorder ?? theme.enabledBorder,
      border: border ?? theme.border,
      alignLabelWithHint: alignLabelWithHint ?? theme.alignLabelWithHint,
      constraints: constraints ?? theme.constraints,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is InputDecoration &&
        other.icon == icon &&
        other.label == label &&
        other.labelText == labelText &&
        other.labelStyle == labelStyle &&
        other.floatingLabelStyle == floatingLabelStyle &&
        other.helperText == helperText &&
        other.helperStyle == helperStyle &&
        other.helperMaxLines == helperMaxLines &&
        other.hintText == hintText &&
        other.hintStyle == hintStyle &&
        other.hintTextDirection == hintTextDirection &&
        other.hintMaxLines == hintMaxLines &&
        other.errorText == errorText &&
        other.errorStyle == errorStyle &&
        other.errorMaxLines == errorMaxLines &&
        other.floatingLabelBehavior == floatingLabelBehavior &&
        other.isDense == isDense &&
        other.contentPadding == contentPadding &&
        other.isCollapsed == isCollapsed &&
        other.prefixIcon == prefixIcon &&
        other.prefix == prefix &&
        other.prefixText == prefixText &&
        other.prefixStyle == prefixStyle &&
        other.prefixIconConstraints == prefixIconConstraints &&
        other.suffixIcon == suffixIcon &&
        other.suffix == suffix &&
        other.suffixText == suffixText &&
        other.suffixStyle == suffixStyle &&
        other.suffixIconConstraints == suffixIconConstraints &&
        other.counter == counter &&
        other.counterText == counterText &&
        other.counterStyle == counterStyle &&
        other.filled == filled &&
        other.fillColor == fillColor &&
        other.focusColor == focusColor &&
        other.hoverColor == hoverColor &&
        other.errorBorder == errorBorder &&
        other.focusedBorder == focusedBorder &&
        other.focusedErrorBorder == focusedErrorBorder &&
        other.disabledBorder == disabledBorder &&
        other.enabledBorder == enabledBorder &&
        other.border == border &&
        other.enabled == enabled &&
        other.semanticCounterText == semanticCounterText &&
        other.alignLabelWithHint == alignLabelWithHint &&
        other.constraints == constraints;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      icon,
      label,
      labelText,
      floatingLabelStyle,
      labelStyle,
      helperText,
      helperStyle,
      helperMaxLines,
      hintText,
      hintStyle,
      hintTextDirection,
      hintMaxLines,
      errorText,
      errorStyle,
      errorMaxLines,
      floatingLabelBehavior,
      isDense,
      contentPadding,
      isCollapsed,
      filled,
      fillColor,
      focusColor,
      hoverColor,
      border,
      enabled,
      prefixIcon,
      prefix,
      prefixText,
      prefixStyle,
      prefixIconConstraints,
      suffixIcon,
      suffix,
      suffixText,
      suffixStyle,
      suffixIconConstraints,
      counter,
      counterText,
      counterStyle,
      errorBorder,
      focusedBorder,
      focusedErrorBorder,
      disabledBorder,
      enabledBorder,
      border,
      enabled,
      semanticCounterText,
      alignLabelWithHint,
      constraints,
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() {
    final List<String> description = <String>[
      if (icon != null) 'icon: $icon',
      if (label != null) 'label: $label',
      if (labelText != null) 'labelText: "$labelText"',
      if (floatingLabelStyle != null)
        'floatingLabelStyle: "$floatingLabelStyle"',
      if (helperText != null) 'helperText: "$helperText"',
      if (helperMaxLines != null) 'helperMaxLines: "$helperMaxLines"',
      if (hintText != null) 'hintText: "$hintText"',
      if (hintMaxLines != null) 'hintMaxLines: "$hintMaxLines"',
      if (errorText != null) 'errorText: "$errorText"',
      if (errorStyle != null) 'errorStyle: "$errorStyle"',
      if (errorMaxLines != null) 'errorMaxLines: "$errorMaxLines"',
      if (floatingLabelBehavior != null)
        'floatingLabelBehavior: $floatingLabelBehavior',
      if (isDense ?? false) 'isDense: $isDense',
      if (contentPadding != null) 'contentPadding: $contentPadding',
      if (isCollapsed) 'isCollapsed: $isCollapsed',
      if (prefixIcon != null) 'prefixIcon: $prefixIcon',
      if (prefix != null) 'prefix: $prefix',
      if (prefixText != null) 'prefixText: $prefixText',
      if (prefixStyle != null) 'prefixStyle: $prefixStyle',
      if (prefixIconConstraints != null)
        'prefixIconConstraints: $prefixIconConstraints',
      if (suffixIcon != null) 'suffixIcon: $suffixIcon',
      if (suffix != null) 'suffix: $suffix',
      if (suffixText != null) 'suffixText: $suffixText',
      if (suffixStyle != null) 'suffixStyle: $suffixStyle',
      if (suffixIconConstraints != null)
        'suffixIconConstraints: $suffixIconConstraints',
      if (counter != null) 'counter: $counter',
      if (counterText != null) 'counterText: $counterText',
      if (counterStyle != null) 'counterStyle: $counterStyle',
      if (filled == true)
        'filled: true', // filled == null same as filled == false
      if (fillColor != null) 'fillColor: $fillColor',
      if (focusColor != null) 'focusColor: $focusColor',
      if (hoverColor != null) 'hoverColor: $hoverColor',
      if (errorBorder != null) 'errorBorder: $errorBorder',
      if (focusedBorder != null) 'focusedBorder: $focusedBorder',
      if (focusedErrorBorder != null) 'focusedErrorBorder: $focusedErrorBorder',
      if (disabledBorder != null) 'disabledBorder: $disabledBorder',
      if (enabledBorder != null) 'enabledBorder: $enabledBorder',
      if (border != null) 'border: $border',
      if (!enabled) 'enabled: false',
      if (semanticCounterText != null)
        'semanticCounterText: $semanticCounterText',
      if (alignLabelWithHint != null) 'alignLabelWithHint: $alignLabelWithHint',
      if (constraints != null) 'constraints: $constraints',
    ];
    return 'InputDecoration(${description.join(', ')})';
  }
}
