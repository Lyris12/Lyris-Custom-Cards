--created & coded by Lyris
--ＳＳ－サブテリジェンス
function c101010154.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101010154.condition)
	e1:SetTarget(c101010154.target)
	e1:SetOperation(c101010154.operation)
	c:RegisterEffect(e1)
end
function c101010154.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and ep==tp
end
function c101010154.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101010154.filter(c,e)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup() and c~=e:GetHandler()
end
function c101010154.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(c101010154.filter,tp,LOCATION_MZONE,0,1,tc,e) and at:IsDestructable() and not at:IsImmuneToEffect(e) then
			local atk=at:GetBaseAttack()
			--if atk<0 then atk=0 end
			if Duel.Destroy(at,REASON_EFFECT)~=0 then
				Duel.Damage(1-tp,atk/2,REASON_EFFECT)
			end
		end
	end
end
function c101010154.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
