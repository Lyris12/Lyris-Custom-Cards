--created & coded by Lyris
--ディメンション魔導士ブラック・マジシャン
function c101010394.initial_effect(c)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCountLimit(1)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ae1:SetTarget(c101010394.target)
	ae1:SetOperation(c101010394.operation)
	c:RegisterEffect(ae1)
	if not c101010394.global_check then
		c101010394.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(500)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010394.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010394.spatial=true
function c101010394.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
function c101010394.material(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c101010394.filter(c,e,tp)
	return c:IsFaceup() and c:IsLevelBelow(7) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010394.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c101010394.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010394.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010394.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010394.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
