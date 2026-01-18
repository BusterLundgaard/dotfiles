#!/usr/bin/env python3
"""
Hunspell Dictionary Processor
Extract stems and generate derivatives from Hunspell dictionaries

Usage:
    # Extract all stems
    python hunspell_processor.py extract-stems en_US.dic en_US.aff -o stems.txt
    
    # Find derivatives of a word
    python hunspell_processor.py derivatives en_US.dic en_US.aff run
"""

import re
import argparse
from collections import defaultdict
from typing import Dict, List, Set, Tuple


class HunspellProcessor:
    def __init__(self, dic_path: str, aff_path: str):
        self.dic_path = dic_path
        self.aff_path = aff_path
        self.affixes = {'PFX': {}, 'SFX': {}}
        self.words = {}  # word -> flags
        self._load_affix_file()
        self._load_dictionary_file()
    
    def _load_affix_file(self):
        """Parse the .aff file to extract prefix and suffix rules"""
        with open(self.aff_path, 'r', encoding='utf-8', errors='ignore') as f:
            current_flag = None
            affix_type = None
            
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                
                parts = line.split()
                if not parts:
                    continue
                
                # PFX or SFX declaration
                if parts[0] in ('PFX', 'SFX'):
                    affix_type = parts[0]
                    if len(parts) >= 4:
                        flag = parts[1]
                        cross_product = parts[2] == 'Y'
                        if flag not in self.affixes[affix_type]:
                            self.affixes[affix_type][flag] = {
                                'cross_product': cross_product,
                                'rules': []
                            }
                        current_flag = flag
                # Affix rule
                elif current_flag and len(parts) >= 4:
                    flag = parts[0]
                    if flag == current_flag:
                        strip = parts[1] if parts[1] != '0' else ''
                        affix = parts[2] if parts[2] != '0' else ''
                        condition = parts[3] if len(parts) > 3 else '.'
                        
                        self.affixes[affix_type][current_flag]['rules'].append({
                            'strip': strip,
                            'affix': affix,
                            'condition': condition
                        })
    
    def _load_dictionary_file(self):
        """Parse the .dic file to extract words and their flags"""
        with open(self.dic_path, 'r', encoding='utf-8', errors='ignore') as f:
            # Skip the first line (word count)
            next(f, None)
            
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                
                # Format: word/FLAGS or just word
                if '/' in line:
                    word, flags = line.split('/', 1)
                    # Remove any trailing data after flags
                    flags = flags.split()[0] if flags else ''
                    self.words[word] = list(flags)
                else:
                    self.words[line] = []
    
    def _matches_condition(self, word: str, condition: str, is_suffix: bool) -> bool:
        """Check if word matches the condition pattern"""
        if condition == '.':
            return True
        
        # Simple pattern matching (not full regex)
        try:
            if is_suffix:
                return re.match(f".*{condition}$", word) is not None
            else:
                return re.match(f"^{condition}", word) is not None
        except:
            return True
    
    def generate_derivatives(self, base_word: str) -> Set[str]:
        """Generate all derivatives of a base word"""
        if base_word not in self.words:
            return set()
        
        derivatives = {base_word}
        flags = self.words[base_word]
        
        # Apply suffixes
        for flag in flags:
            if flag in self.affixes['SFX']:
                affix_data = self.affixes['SFX'][flag]
                for rule in affix_data['rules']:
                    if self._matches_condition(base_word, rule['condition'], True):
                        # Strip from end and add suffix
                        if rule['strip']:
                            if base_word.endswith(rule['strip']):
                                stem = base_word[:-len(rule['strip'])]
                                new_word = stem + rule['affix']
                                derivatives.add(new_word)
                        else:
                            new_word = base_word + rule['affix']
                            derivatives.add(new_word)
        
        # Apply prefixes
        for flag in flags:
            if flag in self.affixes['PFX']:
                affix_data = self.affixes['PFX'][flag]
                for rule in affix_data['rules']:
                    if self._matches_condition(base_word, rule['condition'], False):
                        # Strip from beginning and add prefix
                        if rule['strip']:
                            if base_word.startswith(rule['strip']):
                                stem = base_word[len(rule['strip']):]
                                new_word = rule['affix'] + stem
                                derivatives.add(new_word)
                        else:
                            new_word = rule['affix'] + base_word
                            derivatives.add(new_word)
        
        # Handle cross products (prefix + suffix combinations)
        pfx_flags = [f for f in flags if f in self.affixes['PFX'] and 
                     self.affixes['PFX'][f]['cross_product']]
        sfx_flags = [f for f in flags if f in self.affixes['SFX'] and 
                     self.affixes['SFX'][f]['cross_product']]
        
        for pfx_flag in pfx_flags:
            for sfx_flag in sfx_flags:
                # Apply suffix first, then prefix to the result
                for sfx_rule in self.affixes['SFX'][sfx_flag]['rules']:
                    if self._matches_condition(base_word, sfx_rule['condition'], True):
                        if sfx_rule['strip'] and base_word.endswith(sfx_rule['strip']):
                            stem = base_word[:-len(sfx_rule['strip'])]
                            suffixed = stem + sfx_rule['affix']
                        else:
                            suffixed = base_word + sfx_rule['affix']
                        
                        for pfx_rule in self.affixes['PFX'][pfx_flag]['rules']:
                            if self._matches_condition(suffixed, pfx_rule['condition'], False):
                                if pfx_rule['strip'] and suffixed.startswith(pfx_rule['strip']):
                                    stem = suffixed[len(pfx_rule['strip']):]
                                    final = pfx_rule['affix'] + stem
                                else:
                                    final = pfx_rule['affix'] + suffixed
                                derivatives.add(final)
        
        return derivatives
    
    def extract_all_stems(self) -> List[str]:
        """Extract all base words (stems) from the dictionary"""
        return sorted(self.words.keys())


def main():
    parser = argparse.ArgumentParser(description='Process Hunspell dictionaries')
    subparsers = parser.add_subparsers(dest='command', help='Command to run')
    
    # Extract stems command
    extract_parser = subparsers.add_parser('extract-stems', 
                                          help='Extract all stem words')
    extract_parser.add_argument('dic_file', help='Path to .dic file')
    extract_parser.add_argument('aff_file', help='Path to .aff file')
    extract_parser.add_argument('-o', '--output', default='stems.txt',
                               help='Output file (default: stems.txt)')
    
    # Derivatives command
    deriv_parser = subparsers.add_parser('derivatives',
                                        help='Find derivatives of a word')
    deriv_parser.add_argument('dic_file', help='Path to .dic file')
    deriv_parser.add_argument('aff_file', help='Path to .aff file')
    deriv_parser.add_argument('word', help='Base word to find derivatives for')
    deriv_parser.add_argument('-o', '--output', help='Output file (optional)')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return
    
    print(f"Loading Hunspell dictionary...")
    processor = HunspellProcessor(args.dic_file, args.aff_file)
    
    if args.command == 'extract-stems':
        print(f"Extracting stems...")
        stems = processor.extract_all_stems()
        
        with open(args.output, 'w', encoding='utf-8') as f:
            for stem in stems:
                f.write(f"{stem}\n")
        
        print(f"Extracted {len(stems)} stems to {args.output}")
    
    elif args.command == 'derivatives':
        derivatives = processor.generate_derivatives(args.word)
        
        if args.output:
            with open(args.output, 'w', encoding='utf-8') as f:
                for deriv in sorted(derivatives):
                    f.write(f"{deriv}\n")
            print(f"Found {len(derivatives)} derivatives, saved to {args.output}")
        else:
            print(f"Derivatives of '{args.word}':")
            for deriv in sorted(derivatives):
                print(f"  {deriv}")


if __name__ == '__main__':
    main()
