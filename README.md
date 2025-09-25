# Analizador lexico de C utilizando Flex

Un analizador lexico hecho con **Flex**.  
Reconoce keywords, puntuacion, identificadores, operadores, literales, y comentarios (de una o multiples lineas)

---

## Funciones

- Tokeniza las keywords de C (`int`, `float`, `char`, etc.)  
- Reconoce identificadores, integers, floats, char, y string literals  
- Detecta operadores (`+`, `-`, `*`, `/`, `=`, `==`, `!=`, etc.)  
- Maneja puntuacion (`;`, `{}`, `()`, `[]`, etc.)  
- Maneja comentarios de una linea (`//`) y multiples lineas (`/* */`)

---

## Uso

```bash
# Usar make para crear el analizador
make

# Ejecutar lexer en un archivo tipo c o con sintaxis tipo c
./lexer directorio/del/archivo.c

# Limpiar los artefactos
make clean
