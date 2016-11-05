--Dimension-Magica Swordsman
function c101010393.initial_effect(c)
	--While this card is banished, all "Dimension-Magica" and Spatial Monsters gain 500 ATK.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_REMOVED)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetTarget(c101010393.atktg)
	e0:SetValue(500)
	c:RegisterEffect(e0)
	--If this card is banished from the field: You can banish the top 2 cards of your Deck, then target 1 of your banished DARK Spellcaster-Type monsters, except "Dimension-Magica Swordsman"; Special Summon it.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c101010393.cost)
	e1:SetTarget(c101010393.target)
	e1:SetOperation(c101010393.operation)
	c:RegisterEffect(e1)
	--A DARK Spatial Monster that used this card as a Space Material becomes Spellcaster-Type.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c101010393.matcon)
	e2:SetOperation(c101010393.matop)
	c:RegisterEffect(e2)
end
function c101010393.atktg(e,c)
	return c:IsSetCard(0xa03) or c.spatial
end
function c101010393.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return g:IsExists(Card.IsAbleToRemove,2,nil) end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010393.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(101010393)
end
function c101010393.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010393.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101010393.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c101010393.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c101010393.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101010393.matcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetReason(),0x400000)==0x400000 and c:GetReasonCard():IsAttribute(ATTRIBUTE_DARK)
end
function c101010393.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(RACE_SPELLCASTER)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
