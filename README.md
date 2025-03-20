# Craft System DarkRP

Craft System DarkRP is a simple and elegant crafting system for weapons and items designed for DarkRP. This script allows players to craft various weapons and items by combining required materials on a dedicated crafting table. The system is built with flexibility and customization in mind, making it easy to tailor the look and functionality to suit your server's style.

## Features

- **Simple Crafting Mechanic:** Combine different materials to craft weapons and items.
- **Customizable UI:** The crafting menu (DFrame) is easy to modify, so you can match it with your server’s theme.
- **Easy Item Addition:** Adding new craftable items is straightforward—just define a new recipe with the required materials.
- **DarkRP Compatibility:** Designed specifically with DarkRP in mind, including built-in notifications for crafting success or failure.

## Interface Screenshot

![Interface Craft System DarkRP](https://imgur.com/a/jwkfuSr)

## Getting Started

### Installation

1. **Download the Script:** Clone or download the repository.
2. **Place in Your Server:** Copy the folder into your server's `addons` directory.
3. **Restart Your Server:** Restart your server to load the new crafting system.

### Usage

- **Crafting Table:** Players can interact with the Craft Table to open the crafting menu.
- **Adding Recipes:** Open the `shared.lua` file and locate the `ENT.Recipes` table. You can add new recipes by following the existing format:
  ```lua
  ["your_new_item"] = {
      name = "Your New Item",
      desc = "Description of your new item.",
      materials = {
          { class = "craft_material1", required = 2, name = "Material 1" },
          { class = "craft_material2", required = 3, name = "Material 2" },
      },
      result = "your_new_item",
      isEntity = true -- set to true if the result is an entity
  },
  ```
- **Customization:** The DFrame UI is fully customizable. Modify the appearance by editing the elements in the `cl_init.lua` file to match your server’s visual style.

## Customization Tips

- **UI Elements:** Change fonts, colors, and layout settings in the `cl_init.lua` file to blend seamlessly with your server's aesthetic.
- **Notifications:** The system uses DarkRP notifications to inform players about crafting results. Customize the messages in the `init.lua` file if needed.
- **Expandability:** New recipes can be added easily without affecting the core functionality, allowing you to expand the crafting system as your server grows.

## Contributing

Contributions are welcome! If you have suggestions, bug fixes, or new features, feel free to fork the repository and submit a pull request.

## License

This project is licensed under the MIT License.

```
The MIT License (MIT)

Copyright (c) 2025 Thomas Rendes (aka Etherinus)

1. Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
2. The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
