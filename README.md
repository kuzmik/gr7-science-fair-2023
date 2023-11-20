## Grade 7 Science Fair - 2023

I may have used ChatGPT to help generate some of this, because A) it's not **MY** science fair project an B) I didn't want to have to learn to deal with images in code.

### To get images

1. Open each day/trial image in pixelmator
2. Use the "quick selection" tool (hotkey: `q`)
3. Select as much of a rose as possible, copy to clipboard (hotkey: `cmd-c`)
4. Create a new image using the clipboard (hotkey: `alt-n`)
5. Export the image as a png to the `DAY-TRIAL_NUM` directory (ex: 1-1, 10-3, etc). Filenames should follow this pattern:
    - 1.png - control
    - 2.png - distilled water
    - 3.png - salt
    - 4.png - aspirin
    - 5.png - seven up
    - 6.png - bleach
    - 7.png - vinegar
    - 8.png - sugar
    - 9.png - plant food
6. Run the code: `ruby ./process.rb`
    - Running the code serializes the dataset to a file, because the process takes ~30s to run. To start fresh, just delete `serialized_data.dat`
7. Open `output.csv` in numbers/google sheets/whatever
