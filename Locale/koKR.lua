--[[ $Id$ ]]
local L = LibStub("AceLocale-3.0"):NewLocale("Mapster", "koKR")
if not L then return end

-- Mapster Config
L["intro_desc"] = "Mapster는 월드맵에 여러 가지 추가 기능을 부여합니다. 맵의 스타일 변경 등 확장 플러그인에 대한 설정이 가능합니다."
L["Style"] = "스타일"
L["alpha_desc"] = "월드맵의 투명도를 변경합니다."
L["Alpha"] = "투명도"
L["scale_desc"] = "월드맵의 크기를 변경합니다."
L["Scale"] = "크기"

-- Coords
L["Coordinates"] = "좌표" -- name of the module
L["coords_desc"] = "좌표 모듈은 현재 캐릭터의 위치에 좌표를 표시합니다. 또한 마우스 커서가 위치한 곳의 좌표도 표시합니다."
L["Enable Coordinates"] = "좌표 모듈 사용"
L["Accuracy"] = "좌표 자릿수"
L["coords_accuracy_desc"] = "\n좌표의 소수점 자릿수를 결정합니다."

L["Cursor"] = "커서"
L["Player"] = "캐릭터"

-- Group Icons
L["Group Icons"] = "파티원" -- name of the module
L["groupicons_desc"] = "월드맵에 파티원의 위치를 아이콘으로 표시합니다. 공격대에서는 직업과 파티도 표시합니다."
L["Enable Group Icons"] = "파티원 표시"

-- FogClear
L["FogClear"] = "미확인 지역 탐색" -- name of the module
L["fogclear_desc"] = "월드맵에 가보지 않은 미확인 지역을 보여줍니다."
L["Enable FogClear"] = "미확인 지역 탐색 가능"
L["fogclear_desc_color"] = "현재 캐릭터가 가보지 않은 지역을 볼 수 있게 합니다. 해당지역에 색상을 지정하여 가본 지역과 구분하여 표시할 수 있습니다."
L["Overlay Color"] = "미확인 지역 색상"
